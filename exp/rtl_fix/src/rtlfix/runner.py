"""Experiment driver: run one (model, configuration) cell over VerilogEval."""

from __future__ import annotations

import argparse
import json
import os
import platform
import shutil
import subprocess
import sys
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from rtlfix import classify, compiler, dataset  # noqa: E402
from rtlfix.agent import CONFIGS, run_agent  # noqa: E402
from rtlfix.llm import ChatClient  # noqa: E402


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, required=True)
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--config", choices=sorted(CONFIGS), required=True)
    parser.add_argument("--model-label", required=True,
                        help="short name used in the report tables, e.g. qwen38_next")
    parser.add_argument("--base-url", default=os.environ.get("BASE_URL", ""))
    parser.add_argument("--model-name", default=os.environ.get("MODEL_NAME", ""))
    parser.add_argument("--problems", nargs="*", default=None,
                        help="explicit problem names (default: the full set)")
    parser.add_argument("--limit", type=int, default=0, help="only the first N problems")
    parser.add_argument("--jobs", type=int, default=int(os.environ.get("JOBS", "4")))
    parser.add_argument("--max-iters", type=int, default=10,
                        help="RTLFixer uses at most 10 Thought-Action-Observation steps")
    parser.add_argument("--temperature", type=float, default=0.4,
                        help="RTLFixer sets the sampling temperature to 0.4")
    parser.add_argument("--max-tokens", type=int, default=2048)
    parser.add_argument("--timeout", type=int, default=900)
    parser.add_argument("--resume", action="store_true",
                        help="skip problems that already have a record")
    args = parser.parse_args(argv)
    if not args.base_url or not args.model_name:
        parser.error("--base-url and --model-name (or BASE_URL/MODEL_NAME) are required")
    return args


def run_problem(problem_name: str, args: argparse.Namespace) -> dict:
    problem = dataset.load_problem(args.repo_root, problem_name)
    problem_dir = args.out_dir / "problems" / problem_name
    problem_dir.mkdir(parents=True, exist_ok=True)

    client = ChatClient(
        base_url=args.base_url,
        model=args.model_name,
        temperature=args.temperature,
        max_tokens=args.max_tokens,
        timeout=args.timeout,
    )

    wall_start = time.monotonic()
    result = run_agent(client, problem.prompt, args.config, problem_dir, args.max_iters)

    (problem_dir / "transcript.json").write_text(
        json.dumps(result.transcript, indent=2, ensure_ascii=False) + "\n"
    )
    (problem_dir / "TopModule.sv").write_text(result.code or "")

    if result.code.strip():
        sim = compiler.simulate(result.code, problem.test_path, problem.ref_path, problem_dir)
    else:
        sim = compiler.SimulationResult("compile_error", "no code produced")
    (problem_dir / "grade.log").write_text(sim.log)

    outcome = classify.classify_outcome(sim.status, result.code, result.error)
    record = {
        "problem": problem_name,
        "topic": classify.classify_topic(problem_name, problem.prompt),
        "outcome": outcome,
        "passed": int(outcome == "pass"),
        "compiled": int(sim.status not in ("compile_error",)) if result.code.strip() else 0,
        "error_kind": (
            classify.classify_compile_error(sim.log) if outcome == "compile_error" else ""
        ),
        "mismatches": sim.mismatches,
        "samples": sim.samples,
        "iterations": result.iterations,
        "finished": int(result.finished),
        "tool_calls": result.tool_calls_seen,
        "code_from_tool": int(result.code_from_tool),
        "agent_error": result.error,
        "wall_seconds": round(time.monotonic() - wall_start, 3),
        **result.tool_stats,
        **result.usage,
    }
    (problem_dir / "record.json").write_text(
        json.dumps(record, indent=2, ensure_ascii=False) + "\n"
    )
    return record


def environment_info(args: argparse.Namespace) -> dict:
    def _run(cmd: list[str]) -> str:
        try:
            return subprocess.run(cmd, text=True, capture_output=True, timeout=20).stdout.strip()
        except Exception:  # noqa: BLE001 - provenance only, never fatal
            return ""

    return {
        "started_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "host": platform.node(),
        "platform": platform.platform(),
        "python": platform.python_version(),
        "iverilog": _run(["iverilog", "-V"]).splitlines()[:1],
        "git_commit": _run(["git", "-C", str(args.repo_root), "rev-parse", "HEAD"]),
        "base_url": args.base_url,
        "model_name": args.model_name,
        "model_label": args.model_label,
        "config": args.config,
        "config_description": CONFIGS[args.config]["description"],
        "temperature": args.temperature,
        "max_tokens": args.max_tokens,
        "max_iters": args.max_iters,
        "jobs": args.jobs,
    }


def summarise(records: list[dict], meta: dict, elapsed: float) -> dict:
    total = len(records)
    passed = sum(r["passed"] for r in records)
    compiled = sum(r["compiled"] for r in records)
    outcomes: dict[str, int] = {}
    error_kinds: dict[str, int] = {}
    topics: dict[str, dict[str, int]] = {}
    for record in records:
        outcomes[record["outcome"]] = outcomes.get(record["outcome"], 0) + 1
        if record["error_kind"]:
            error_kinds[record["error_kind"]] = error_kinds.get(record["error_kind"], 0) + 1
        bucket = topics.setdefault(record["topic"], {"total": 0, "passed": 0})
        bucket["total"] += 1
        bucket["passed"] += record["passed"]
    return {
        "meta": meta,
        "total": total,
        "passed": passed,
        "pass_rate": passed / total if total else 0.0,
        "compiled": compiled,
        "compile_rate": compiled / total if total else 0.0,
        "wall_seconds_total": round(elapsed, 3),
        "wall_seconds_mean": round(
            sum(r["wall_seconds"] for r in records) / total, 3
        ) if total else 0.0,
        "prompt_tokens": sum(r["prompt_tokens"] for r in records),
        "completion_tokens": sum(r["completion_tokens"] for r in records),
        "total_tokens": sum(r["total_tokens"] for r in records),
        "llm_calls": sum(r["llm_calls"] for r in records),
        "compile_calls": sum(r["compile_calls"] for r in records),
        "rag_calls": sum(r["rag_calls"] for r in records),
        "outcomes": dict(sorted(outcomes.items())),
        "error_kinds": dict(sorted(error_kinds.items())),
        "topics": dict(sorted(topics.items())),
        "results": records,
    }


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    missing = [tool for tool in ("iverilog", "vvp") if shutil.which(tool) is None]
    if missing:
        print(f"error: missing required tool(s): {', '.join(missing)}", file=sys.stderr)
        return 2

    problems = args.problems or dataset.list_problems(args.repo_root)
    if args.limit:
        problems = problems[: args.limit]

    args.out_dir.mkdir(parents=True, exist_ok=True)
    summary_path = args.out_dir / "summary.json"

    done: dict[str, dict] = {}
    if args.resume and summary_path.is_file():
        previous = json.loads(summary_path.read_text())
        done = {r["problem"]: r for r in previous.get("results", [])}
        print(f"resuming: {len(done)} problem(s) already recorded")

    pending = [p for p in problems if p not in done]
    meta = environment_info(args)
    print(
        f"[{args.model_label}/{args.config}] {len(pending)} problem(s) to run "
        f"with {args.jobs} worker(s)",
        flush=True,
    )

    lock = threading.Lock()
    started = time.monotonic()

    def flush() -> None:
        ordered = [done[p] for p in problems if p in done]
        summary = summarise(ordered, meta, time.monotonic() - started)
        tmp = summary_path.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n")
        tmp.replace(summary_path)

    if pending:
        with ThreadPoolExecutor(max_workers=max(1, min(args.jobs, len(pending)))) as pool:
            futures = {pool.submit(run_problem, name, args): name for name in pending}
            for index, future in enumerate(as_completed(futures), start=1):
                name = futures[future]
                try:
                    record = future.result()
                except Exception as exc:  # noqa: BLE001 - one problem must not kill the run
                    record = {
                        "problem": name, "topic": "other", "outcome": "api_error",
                        "passed": 0, "compiled": 0, "error_kind": "", "mismatches": None,
                        "samples": None, "iterations": 0, "finished": 0, "tool_calls": 0,
                        "code_from_tool": 0, "agent_error": repr(exc), "wall_seconds": 0.0,
                        "compile_calls": 0, "rag_calls": 0, "rag_entries_hit": [],
                        "llm_calls": 0, "prompt_tokens": 0, "completion_tokens": 0,
                        "total_tokens": 0,
                    }
                with lock:
                    done[name] = record
                    flush()
                print(
                    f"[{index}/{len(pending)}] {name}: {record['outcome']} "
                    f"({record['wall_seconds']:.1f}s, {record['total_tokens']} tok)",
                    flush=True,
                )
    flush()

    summary = json.loads(summary_path.read_text())
    print(
        f"pass {summary['passed']}/{summary['total']} ({summary['pass_rate']:.1%}) | "
        f"compile {summary['compile_rate']:.1%} | "
        f"{summary['total_tokens']} tokens | {summary['wall_seconds_total']:.0f}s"
    )
    print(f"results: {args.out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
