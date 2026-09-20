"""Pull a Verilog module out of free-form model output."""

from __future__ import annotations

import re

_BEGIN_DONE = re.compile(r"\[BEGIN\](.*?)\[DONE\]", re.DOTALL | re.IGNORECASE)
_FENCED = re.compile(
    r"```(?:systemverilog|verilog|sv)?[^\S\n]*\n(.*?)```", re.DOTALL | re.IGNORECASE
)
_MODULE = re.compile(r"\bmodule\s+\w+\b.*\bendmodule\b", re.DOTALL)


def extract_verilog(text: str) -> str:
    """Return the module body, preferring the last fenced block."""
    if not text:
        return ""

    begin_done = _BEGIN_DONE.search(text)
    if begin_done:
        text = begin_done.group(1)
    else:
        blocks = _FENCED.findall(text)
        if blocks:
            # The last block is the agent's final revision.
            text = blocks[-1]

    module = _MODULE.search(text)
    if module:
        return module.group(0).strip() + "\n"
    return text.strip() + "\n" if text.strip() else ""
