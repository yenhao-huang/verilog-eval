"""Access to the VerilogEval spec-to-rtl problem set."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

DATASET_DIRNAME = "dataset_spec-to-rtl"


@dataclass
class Problem:
    name: str
    prompt: str
    test_path: Path
    ref_path: Path


def dataset_dir(repo_root: Path) -> Path:
    return repo_root / DATASET_DIRNAME


def list_problems(repo_root: Path) -> list[str]:
    path = dataset_dir(repo_root) / "problems.txt"
    return [line.strip() for line in path.read_text().splitlines() if line.strip()]


def load_problem(repo_root: Path, name: str) -> Problem:
    root = dataset_dir(repo_root)
    prompt_path = root / f"{name}_prompt.txt"
    if not prompt_path.is_file():
        raise FileNotFoundError(f"unknown problem: {name}")
    return Problem(
        name=name,
        prompt=prompt_path.read_text(),
        test_path=root / f"{name}_test.sv",
        ref_path=root / f"{name}_ref.sv",
    )
