#!/usr/bin/env python3
"""Evaluate qwen3.8-flash-next on VerilogEval spec-to-RTL problems."""

from __future__ import annotations

import argparse
import csv
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path


SYSTEM_PROMPT = """You are a Verilog RTL designer. Return only syntactically correct SystemVerilog. Implement exactly one module named TopModule with the requested interface. Do not include explanations."""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate and score VerilogEval solutions through a vLLM endpoint."
    )
    parser.add_argument("mode", choices=("one", "all"), nargs="?", default="one")
    parser.add_argument("problem", nargs="?", default="Prob001_zero")
    parser.add_argument("--repo-root", type=Path, required=True)
    parser.add_argument("--max-tokens", type=int, default=2048)
    parser.add_argument("--timeout", type=int, default=180)
    parser.add_argument(
        "--jobs",
        type=int,
        default=int(os.environ.get("JOBS", "4")),
        help="number of problems evaluated concurrently (default: JOBS or 4)",
    )
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be at least 1")
    return args


def extract_verilog(response: str) -> str:
    begin_done = re.search(r"\[BEGIN\](.*?)\[DONE\]", response, re.DOTALL | re.IGNORECASE)
    if begin_done:
        response = begin_done.group(1)
    else:
        fenced = re.search(r"```(?:systemverilog|verilog|sv)?\s*(.*?)```", response, re.DOTALL | re.IGNORECASE)
        if fenced:
            response = fenced.group(1)

    module = re.search(r"\bmodule\s+TopModule\b.*?\bendmodule\b", response, re.DOTALL)
    return (module.group(0) if module else response).strip() + "\n"


def request_solution(base_url: str, model: str, prompt: str, max_tokens: int, timeout: int) -> tuple[str, dict]:
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt},
        ],
        "temperature": 0,
        "top_p": 1,
        "max_tokens": max_tokens,
    }
    request = urllib.request.Request(
        f"{base_url.rstrip('/')}/chat/completions",
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json", "Authorization": "Bearer EMPTY"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=timeout) as response:
        result = json.load(response)
    return result["choices"][0]["message"]["content"], result


def score_problem(dataset: Path, output_dir: Path, problem: str, args: argparse.Namespace) -> dict:
    problem_dir = output_dir / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    prompt_path = dataset / f"{problem}_prompt.txt"
    test_path = dataset / f"{problem}_test.sv"
    ref_path = dataset / f"{problem}_ref.sv"
    generated_path = problem_dir / f"{problem}.sv"
    raw_path = problem_dir / "response.json"
    log_path = problem_dir / "iverilog.log"

    record = {"problem": problem, "status": "api_error", "passed": 0, "mismatches": "", "error": ""}
    prompt = prompt_path.read_text()
    (problem_dir / "prompt.txt").write_text(prompt)

    try:
        content, raw = request_solution(
            os.environ["VLLM_BASE_URL"], os.environ["MODEL_NAME"], prompt, args.max_tokens, args.timeout
        )
        raw_path.write_text(json.dumps(raw, indent=2, ensure_ascii=False) + "\n")
        generated_path.write_text(extract_verilog(content))
    except (urllib.error.URLError, TimeoutError, KeyError, json.JSONDecodeError) as exc:
        record["error"] = str(exc)
        (problem_dir / "api_error.txt").write_text(str(exc) + "\n")
        return record

    binary = problem_dir / "sim.out"
    compile_result = subprocess.run(
        ["iverilog", "-Wall", "-Winfloop", "-Wno-timescale", "-g2012", "-s", "tb", "-o", binary, generated_path, test_path, ref_path],
        text=True,
        capture_output=True,
    )
    log = compile_result.stdout + compile_result.stderr
    if compile_result.returncode != 0:
        log_path.write_text(log)
        record.update(status="compile_error", error=f"iverilog exited {compile_result.returncode}")
        return record

    try:
        sim_result = subprocess.run(
            ["vvp", binary], text=True, capture_output=True, timeout=30, cwd=problem_dir
        )
        log += sim_result.stdout + sim_result.stderr
    except subprocess.TimeoutExpired as exc:
        log += (exc.stdout or "") + (exc.stderr or "") + "\nTIMEOUT\n"
        log_path.write_text(log)
        record.update(status="timeout", error="simulation exceeded 30 seconds")
        return record
    finally:
        binary.unlink(missing_ok=True)

    log_path.write_text(log)
    mismatch = re.search(r"Mismatches:\s*(\d+)\s+in\s+(\d+)\s+samples", log)
    if not mismatch:
        record.update(status="runtime_error", error="simulation did not report mismatches")
    else:
        mismatches = int(mismatch.group(1))
        record.update(
            status="pass" if mismatches == 0 else "fail",
            passed=int(mismatches == 0),
            mismatches=mismatches,
        )
    return record


def write_summary(output_dir: Path, records: list[dict]) -> None:
    total = len(records)
    passed = sum(row["passed"] for row in records)
    summary = {
        "passed": passed,
        "total": total,
        "score": passed / total if total else 0,
        "results": records,
    }
    json_tmp = output_dir / "score.json.tmp"
    csv_tmp = output_dir / "score.csv.tmp"
    json_tmp.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n")
    with csv_tmp.open("w", newline="") as output:
        writer = csv.DictWriter(output, fieldnames=("problem", "status", "passed", "mismatches", "error"))
        writer.writeheader()
        writer.writerows(records)
    json_tmp.replace(output_dir / "score.json")
    csv_tmp.replace(output_dir / "score.csv")
    print(f"score: {passed}/{total} ({summary['score']:.2%})")
    print(f"results: {output_dir}")


def main() -> int:
    args = parse_args()
    dataset = args.repo_root / "dataset_spec-to-rtl"
    output_dir = Path(os.environ["RESULTS_DIR"]).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    missing = [tool for tool in ("iverilog", "vvp") if shutil.which(tool) is None]
    if missing:
        print(f"error: missing required tool(s): {', '.join(missing)}", file=sys.stderr)
        return 2

    if args.mode == "one":
        problems = [args.problem]
    else:
        problems = [line.strip() for line in (dataset / "problems.txt").read_text().splitlines() if line.strip()]

    unknown = [name for name in problems if not (dataset / f"{name}_prompt.txt").is_file()]
    if unknown:
        print(f"error: unknown problem(s): {', '.join(unknown)}", file=sys.stderr)
        return 2

    workers = min(args.jobs, len(problems))
    print(f"evaluating {len(problems)} problem(s) with {workers} parallel worker(s)", flush=True)
    records_by_problem = {}
    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {
            executor.submit(score_problem, dataset, output_dir, problem, args): problem
            for problem in problems
        }
        for completed, future in enumerate(as_completed(futures), start=1):
            problem = futures[future]
            try:
                record = future.result()
            except Exception as exc:
                record = {
                    "problem": problem,
                    "status": "internal_error",
                    "passed": 0,
                    "mismatches": "",
                    "error": str(exc),
                }
            records_by_problem[problem] = record
            records = [records_by_problem[name] for name in problems if name in records_by_problem]
            write_summary(output_dir, records)
            print(f"[{completed}/{len(problems)}] {problem}: {record['status']}", flush=True)
    records = [records_by_problem[name] for name in problems]
    return 0 if all(row["passed"] for row in records) else 1


if __name__ == "__main__":
    raise SystemExit(main())
