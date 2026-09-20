"""Minimal OpenAI-compatible chat client with usage accounting.

Kept dependency-free (urllib only) so the harness runs against either the vLLM
or the llama.cpp server without a virtualenv.
"""

from __future__ import annotations

import json
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from typing import Any


class LLMError(RuntimeError):
    """Raised when the endpoint could not produce a usable response."""


@dataclass
class Usage:
    prompt_tokens: int = 0
    completion_tokens: int = 0
    reasoning_tokens: int = 0
    calls: int = 0
    truncated_calls: int = 0

    @property
    def total_tokens(self) -> int:
        return self.prompt_tokens + self.completion_tokens

    def add(self, raw: dict[str, Any] | None) -> None:
        self.calls += 1
        if not raw:
            return
        self.prompt_tokens += int(raw.get("prompt_tokens") or 0)
        self.completion_tokens += int(raw.get("completion_tokens") or 0)
        details = raw.get("completion_tokens_details") or {}
        self.reasoning_tokens += int(details.get("reasoning_tokens") or 0)

    def as_dict(self) -> dict[str, int]:
        return {
            "llm_calls": self.calls,
            "prompt_tokens": self.prompt_tokens,
            "completion_tokens": self.completion_tokens,
            "reasoning_tokens": self.reasoning_tokens,
            "total_tokens": self.total_tokens,
            "truncated_calls": self.truncated_calls,
        }


@dataclass
class ChatClient:
    base_url: str
    model: str
    temperature: float = 0.4
    max_tokens: int = 8192
    timeout: int = 600
    retries: int = 3
    retry_backoff: float = 5.0
    usage: Usage = field(default_factory=Usage)

    def complete(
        self,
        messages: list[dict[str, Any]],
        tools: list[dict[str, Any]] | None = None,
    ) -> dict[str, Any]:
        """Return the assistant message of one chat completion."""
        payload: dict[str, Any] = {
            "model": self.model,
            "messages": messages,
            "temperature": self.temperature,
            "top_p": 1,
            "max_tokens": self.max_tokens,
        }
        if tools:
            payload["tools"] = tools
            payload["tool_choice"] = "auto"

        request = urllib.request.Request(
            f"{self.base_url.rstrip('/')}/chat/completions",
            data=json.dumps(payload).encode(),
            headers={
                "Content-Type": "application/json",
                "Authorization": "Bearer EMPTY",
            },
            method="POST",
        )

        last_error: Exception | None = None
        for attempt in range(self.retries):
            try:
                with urllib.request.urlopen(request, timeout=self.timeout) as response:
                    result = json.load(response)
                break
            except urllib.error.HTTPError as exc:  # 4xx/5xx carry a useful body
                body = exc.read().decode(errors="replace")[:500]
                last_error = LLMError(f"HTTP {exc.code}: {body}")
                if exc.code < 500:
                    raise last_error from exc
            except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as exc:
                last_error = exc
            time.sleep(self.retry_backoff * (attempt + 1))
        else:
            raise LLMError(str(last_error))

        self.usage.add(result.get("usage"))
        try:
            choice = result["choices"][0]
            message = choice["message"]
        except (KeyError, IndexError) as exc:
            raise LLMError(f"malformed response: {json.dumps(result)[:500]}") from exc
        finish_reason = choice.get("finish_reason") or ""
        if finish_reason == "length":
            self.usage.truncated_calls += 1
        message = dict(message)
        message["_finish_reason"] = finish_reason
        return message
