"""Retrieval over the curated compiler-error -> expert-guidance database.

RTLFixer (section 3.3) uses "an exact match to error tags for simplicity, given
the limited number of error cases". We keep that retriever: each entry lists
substrings that must appear in the compiler log.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

DEFAULT_DB = Path(__file__).resolve().parents[2] / "knowledge" / "iverilog_guidance.json"


@dataclass
class GuidanceDB:
    entries: list[dict]
    fallback: str

    @classmethod
    def load(cls, path: Path = DEFAULT_DB) -> "GuidanceDB":
        raw = json.loads(path.read_text())
        return cls(entries=raw["entries"], fallback=raw["fallback"])

    def _matches(self, entry: dict, log: str) -> bool:
        haystack = log.lower() if entry.get("case_insensitive") else log
        needles = entry["match"]
        if entry.get("case_insensitive"):
            needles = [n.lower() for n in needles]
        hit = (
            any(n in haystack for n in needles)
            if entry.get("any_of")
            else all(n in haystack for n in needles)
        )
        if not hit:
            return False
        return not any(n in haystack for n in entry.get("not_match", []))

    def lookup(self, compiler_log: str) -> tuple[str, list[str]]:
        """Return (guidance text, ids of the entries that fired)."""
        if not compiler_log:
            return "", []
        fired = [e for e in self.entries if self._matches(e, compiler_log)]
        if not fired:
            return self.fallback, []
        lines = ["Fix suggestions:"] + [f"* {e['guidance']}" for e in fired]
        return "\n".join(lines), [e["id"] for e in fired]
