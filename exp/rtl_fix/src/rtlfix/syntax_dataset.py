"""RTLFixer's VerilogEval-syntax dataset: erroneous implementations to repair.

This is the dataset the paper's Table 1 (fix rate) is measured on. Fetch it with
``scripts/fetch_syntax_dataset.sh``; it is not vendored here.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

DEFAULT_PATH = Path(__file__).resolve().parents[2] / "data" / "verilogeval-syntax.jsonl"
PROMPTS_DIR = Path(__file__).resolve().parents[2] / "prompts"


@dataclass
class SyntaxProblem:
    name: str
    task_id: str
    description: str
    module_header: str
    broken_code: str
    compiler_error: str
    test: str

    def user_prompt(self) -> str:
        template = (PROMPTS_DIR / "fix_user_template.txt").read_text()
        return template.format(
            description=self.description.strip(),
            module_header=self.module_header.strip(),
            broken_code=self.broken_code.strip(),
            compiler_error=self.compiler_error.strip(),
        )

    @property
    def broken_module(self) -> str:
        """The erroneous implementation as a standalone compilable module."""
        return self.module_header.rstrip() + "\n" + self.broken_code.lstrip("\n")


def load_all(path: Path = DEFAULT_PATH) -> list[SyntaxProblem]:
    if not path.is_file():
        raise FileNotFoundError(
            f"{path} not found — run scripts/fetch_syntax_dataset.sh first"
        )
    problems: list[SyntaxProblem] = []
    seen: dict[str, int] = {}
    for line in path.read_text().splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        task_id = row["task_id"]
        # task_id repeats across differently-broken samples of the same problem.
        index = seen.get(task_id, 0)
        seen[task_id] = index + 1
        problems.append(
            SyntaxProblem(
                name=f"{task_id}#{index}",
                task_id=task_id,
                description=row.get("detail_description") or "",
                module_header=row["prompt"],
                broken_code=row["solution"],
                compiler_error=row.get("compiler_error") or "",
                test=row["test"],
            )
        )
    return problems


def load_index(path: Path = DEFAULT_PATH) -> dict[str, SyntaxProblem]:
    return {problem.name: problem for problem in load_all(path)}
