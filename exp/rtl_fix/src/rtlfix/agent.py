"""One-shot baseline and the ReAct tool-using agent."""

from __future__ import annotations

import json
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .extract import extract_verilog
from .llm import ChatClient, LLMError
from .tools import Toolkit

PROMPTS_DIR = Path(__file__).resolve().parents[2] / "prompts"

CONFIGS: dict[str, dict[str, Any]] = {
    "baseline": {
        "system_prompt": "system_generate.txt",
        "tools": False,
        "rag": False,
        "description": "One-shot generation, no tools (RTLFixer Figure 2(a) baseline)",
    },
    "react_compiler": {
        "system_prompt": "react_system_runtime_norag.txt",
        "tools": True,
        "rag": False,
        "description": "ReAct with the compiler tool only",
    },
    "react_compiler_rag": {
        "system_prompt": "react_system_runtime.txt",
        "tools": True,
        "rag": True,
        "description": "ReAct with the compiler tool and the RAG expert-guidance tool",
    },
    # --- repair task (RTLFixer's VerilogEval-syntax, the paper's Table 1) ---
    "fix_oneshot": {
        "system_prompt": "fix_system_oneshot.txt",
        "tools": False,
        "rag": False,
        "description": "One-shot repair with a single round of compiler feedback "
                       "(RTLFixer Figure 2(a))",
    },
    "fix_react_compiler": {
        "system_prompt": "fix_system_react_norag.txt",
        "tools": True,
        "rag": False,
        "description": "ReAct repair with the compiler tool only",
    },
    "fix_react_compiler_rag": {
        "system_prompt": "fix_system_react.txt",
        "tools": True,
        "rag": True,
        "description": "ReAct repair with the compiler tool and the RAG "
                       "expert-guidance tool",
    },
}

REPAIR_CONFIGS = ("fix_oneshot", "fix_react_compiler", "fix_react_compiler_rag")


def load_system_prompt(config: str) -> str:
    return (PROMPTS_DIR / CONFIGS[config]["system_prompt"]).read_text().strip()


@dataclass
class AgentResult:
    code: str
    transcript: list[dict[str, Any]]
    iterations: int
    finished: bool
    tool_stats: dict[str, Any]
    usage: dict[str, int]
    elapsed_seconds: float
    final_message: str = ""
    error: str = ""
    # True when the code we hand to the grader is the last snippet that the
    # agent successfully compiled rather than the text of its final reply.
    code_from_tool: bool = False
    tool_calls_seen: int = 0


def _parse_arguments(raw: Any) -> dict:
    if isinstance(raw, dict):
        return raw
    if not raw:
        return {}
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        return {"code_completion": str(raw)}
    return parsed if isinstance(parsed, dict) else {"code_completion": str(parsed)}


def run_baseline(client: ChatClient, prompt: str, config: str = "baseline") -> AgentResult:
    started = time.monotonic()
    system = load_system_prompt(config)
    messages = [
        {"role": "system", "content": system},
        {"role": "user", "content": prompt},
    ]
    try:
        message = client.complete(messages)
    except LLMError as exc:
        return AgentResult(
            code="", transcript=messages, iterations=0, finished=False,
            tool_stats={"compile_calls": 0, "rag_calls": 0, "rag_entries_hit": []},
            usage=client.usage.as_dict(),
            elapsed_seconds=time.monotonic() - started, error=str(exc),
        )
    content = message.get("content") or ""
    finish_reason = message.get("_finish_reason", "")
    messages.append({"role": "assistant", "content": content})
    return AgentResult(
        code=extract_verilog(content),
        transcript=messages,
        iterations=1,
        finished=True,
        tool_stats={"compile_calls": 0, "rag_calls": 0, "rag_entries_hit": []},
        usage=client.usage.as_dict(),
        elapsed_seconds=time.monotonic() - started,
        final_message=content,
        error="response truncated at max_tokens" if finish_reason == "length" else "",
    )


def run_react(
    client: ChatClient,
    prompt: str,
    config: str,
    workdir: Path,
    max_iters: int = 10,
) -> AgentResult:
    """Interleave Thought / Action / Observation until the agent finishes."""
    started = time.monotonic()
    settings = CONFIGS[config]
    toolkit = Toolkit(use_rag=settings["rag"], workdir=workdir)
    schemas = toolkit.schemas()

    messages: list[dict[str, Any]] = [
        {"role": "system", "content": load_system_prompt(config)},
        {"role": "user", "content": prompt},
    ]

    finished = False
    error = ""
    final_message = ""
    tool_calls_seen = 0
    iterations = 0

    for iterations in range(1, max_iters + 1):
        try:
            message = client.complete(messages, tools=schemas)
        except LLMError as exc:
            error = str(exc)
            break

        tool_calls = message.get("tool_calls") or []
        finish_reason = message.get("_finish_reason", "")
        assistant: dict[str, Any] = {
            "role": "assistant",
            "content": message.get("content") or "",
        }
        if tool_calls:
            assistant["tool_calls"] = tool_calls
        messages.append(assistant)

        if not tool_calls:
            final_message = assistant["content"]
            finished = finish_reason != "length"
            if not finished:
                error = "response truncated at max_tokens"
            break

        tool_calls_seen += len(tool_calls)
        for index, call in enumerate(tool_calls):
            function = call.get("function", {})
            name = function.get("name", "")
            arguments = _parse_arguments(function.get("arguments"))
            observation = toolkit.call(name, arguments)
            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": call.get("id") or f"call_{iterations}_{index}",
                    "name": name,
                    "content": observation,
                }
            )
    else:
        error = f"reached the {max_iters}-iteration limit without finishing"

    code = extract_verilog(final_message)
    code_from_tool = False
    # Prefer the last successfully compiled snippet when the closing message
    # carries no code of its own (the agent said "done" without repeating it).
    if not code.strip() and toolkit.last_code.strip():
        code = toolkit.last_code
        code_from_tool = True

    return AgentResult(
        code=code,
        transcript=messages,
        iterations=iterations,
        finished=finished,
        tool_stats=toolkit.stats(),
        usage=client.usage.as_dict(),
        elapsed_seconds=time.monotonic() - started,
        final_message=final_message,
        error=error,
        code_from_tool=code_from_tool,
        tool_calls_seen=tool_calls_seen,
    )


def run_agent(
    client: ChatClient, prompt: str, config: str, workdir: Path, max_iters: int = 10
) -> AgentResult:
    if not CONFIGS[config]["tools"]:
        return run_baseline(client, prompt, config)
    return run_react(client, prompt, config, workdir, max_iters)
