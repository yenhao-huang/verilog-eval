"""The two tools of the agent, plus their OpenAI tool schemas.

Mapping to RTLFixer Figure 2(b):

    Compiler[code] -> verilog_compiler
    RAG[logs]      -> error_lookup
    Finish[answer] -> the model's final assistant message (no tool)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

from .compiler import syntax_check
from .extract import extract_verilog
from .rag import GuidanceDB

COMPILER_TOOL_SCHEMA = {
    "type": "function",
    "function": {
        "name": "verilog_compiler",
        "description": (
            "Compile the input Verilog code and provide the compiler error "
            "message if there is a syntax error."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "code_completion": {
                    "type": "string",
                    "description": (
                        "Valid Verilog code that implements the complete "
                        "TopModule for the given problem."
                    ),
                }
            },
            "required": ["code_completion"],
        },
    },
}

RAG_TOOL_SCHEMA = {
    "type": "function",
    "function": {
        "name": "error_lookup",
        "description": (
            "Input the compiler log and retrieve expert solutions to fix the "
            "syntax error."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "compile_error_message": {
                    "type": "string",
                    "description": "Error message from the Verilog compiler.",
                }
            },
            "required": ["compile_error_message"],
        },
    },
}


@dataclass
class Toolkit:
    """Stateful toolkit: remembers the last code the agent compiled."""

    use_rag: bool
    workdir: Path
    db: GuidanceDB = field(default_factory=GuidanceDB.load)
    last_code: str = ""
    last_compile_ok: bool = False
    last_compile_log: str = ""
    compile_calls: int = 0
    rag_calls: int = 0
    rag_hits: list[str] = field(default_factory=list)

    def schemas(self) -> list[dict]:
        tools = [COMPILER_TOOL_SCHEMA]
        if self.use_rag:
            tools.append(RAG_TOOL_SCHEMA)
        return tools

    def call(self, name: str, arguments: dict) -> str:
        if name == "verilog_compiler":
            return self.verilog_compiler(arguments.get("code_completion", ""))
        if name == "error_lookup":
            return self.error_lookup(arguments.get("compile_error_message", ""))
        return (
            f"Unknown tool '{name}'. Available tools: "
            + ", ".join(t["function"]["name"] for t in self.schemas())
        )

    def verilog_compiler(self, code_completion: str) -> str:
        self.compile_calls += 1
        code = extract_verilog(code_completion)
        if not code.strip():
            return "No Verilog code received. Send the complete TopModule implementation."
        self.last_code = code
        result = syntax_check(code, workdir=self.workdir)
        self.last_compile_ok = result.ok
        self.last_compile_log = result.log
        if result.ok:
            return "The code has no compile error. I should give this implementation to the user."
        return f"compile result: {result.log}\nFix the code and run compile again."

    def error_lookup(self, compile_error_message: str) -> str:
        self.rag_calls += 1
        log = compile_error_message or self.last_compile_log
        guidance, ids = self.db.lookup(log)
        self.rag_hits.extend(ids)
        return guidance or "No expert guidance found for this error."

    def stats(self) -> dict:
        return {
            "compile_calls": self.compile_calls,
            "rag_calls": self.rag_calls,
            "rag_entries_hit": sorted(set(self.rag_hits)),
        }
