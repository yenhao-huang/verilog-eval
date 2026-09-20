"""Icarus Verilog wrappers.

Two distinct uses, deliberately separated:

* :func:`syntax_check` is what the agent's ``verilog_compiler`` tool calls. It
  compiles the candidate module *alone*, so the agent never sees the testbench.
* :func:`simulate` is the offline grader. It links the candidate against the
  VerilogEval testbench and reference and is never exposed to the model.
"""

from __future__ import annotations

import re
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

IVERILOG_FLAGS = ["-Wall", "-Winfloop", "-Wno-timescale", "-g2012"]
SIM_TIMEOUT_SECONDS = 30
COMPILE_TIMEOUT_SECONDS = 60


@dataclass
class CompileResult:
    ok: bool
    log: str

    @property
    def message(self) -> str:
        return "The code has no compile error." if self.ok else self.log


@dataclass
class SimulationResult:
    status: str  # pass | fail | compile_error | timeout | runtime_error
    log: str
    mismatches: int | None = None
    samples: int | None = None

    @property
    def passed(self) -> bool:
        return self.status == "pass"


def syntax_check(code: str, workdir: Path | None = None) -> CompileResult:
    """Compile ``code`` on its own and return the iverilog log."""
    with tempfile.TemporaryDirectory(dir=workdir) as tmp:
        tmp_path = Path(tmp)
        source = tmp_path / "TopModule.sv"
        source.write_text(code if code.endswith("\n") else code + "\n")
        try:
            completed = subprocess.run(
                ["iverilog", *IVERILOG_FLAGS, "-o", str(tmp_path / "a.out"), str(source)],
                text=True,
                capture_output=True,
                timeout=COMPILE_TIMEOUT_SECONDS,
            )
        except subprocess.TimeoutExpired:
            return CompileResult(False, "iverilog timed out after "
                                        f"{COMPILE_TIMEOUT_SECONDS} seconds.")
    log = (completed.stdout + completed.stderr).strip()
    # Rewrite the temp path so the agent sees a stable, paper-like file name.
    log = log.replace(str(source), "TopModule.sv")
    return CompileResult(completed.returncode == 0, log)


def simulate(code: str, test_path: Path, ref_path: Path, workdir: Path) -> SimulationResult:
    """Grade ``code`` against the VerilogEval testbench and reference."""
    workdir.mkdir(parents=True, exist_ok=True)
    source = workdir / "TopModule.sv"
    source.write_text(code if code.endswith("\n") else code + "\n")
    binary = workdir / "sim.out"

    compile_result = subprocess.run(
        [
            "iverilog", *IVERILOG_FLAGS, "-s", "tb", "-o", str(binary),
            str(source), str(test_path), str(ref_path),
        ],
        text=True,
        capture_output=True,
    )
    log = compile_result.stdout + compile_result.stderr
    if compile_result.returncode != 0:
        return SimulationResult("compile_error", log)

    try:
        sim = subprocess.run(
            ["vvp", str(binary)],
            text=True,
            capture_output=True,
            timeout=SIM_TIMEOUT_SECONDS,
            cwd=workdir,
        )
        log += sim.stdout + sim.stderr
    except subprocess.TimeoutExpired as exc:
        log += (exc.stdout or "") + (exc.stderr or "") + "\nTIMEOUT\n"
        return SimulationResult("timeout", log)
    finally:
        binary.unlink(missing_ok=True)

    match = re.search(r"Mismatches:\s*(\d+)\s+in\s+(\d+)\s+samples", log)
    if not match:
        return SimulationResult("runtime_error", log)
    mismatches, samples = int(match.group(1)), int(match.group(2))
    return SimulationResult(
        "pass" if mismatches == 0 else "fail", log, mismatches, samples
    )
