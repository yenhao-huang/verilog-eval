#!/usr/bin/env python3
"""Turn results/<model>/<config>/summary.json into the acceptance tables.

Writes:
  acceptance/details/metrics.csv          one row per (model, config)
  acceptance/details/per_problem.csv      one row per (model, config, problem)
  acceptance/details/tables.md            every markdown table used in reports.md
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

EXP_DIR = Path(__file__).resolve().parents[1]
CONFIG_ORDER = [
    "baseline", "react_compiler", "react_compiler_rag",
    "fix_oneshot", "fix_react_compiler", "fix_react_compiler_rag",
]
CONFIG_LABEL = {
    "baseline": "baseline (no tools)",
    "react_compiler": "ReAct + compiler",
    "react_compiler_rag": "ReAct + compiler + RAG",
    "fix_oneshot": "one-shot fix (compiler feedback)",
    "fix_react_compiler": "ReAct + compiler",
    "fix_react_compiler_rag": "ReAct + compiler + RAG",
}
# Which configuration each family is measured against.
REFERENCE_OF = {
    "react_compiler": "baseline",
    "react_compiler_rag": "baseline",
    "fix_react_compiler": "fix_oneshot",
    "fix_react_compiler_rag": "fix_oneshot",
}
OUTCOME_ORDER = [
    "pass",
    "functional_mismatch",
    "compile_error",
    "simulation_timeout",
    "runtime_error",
    "no_code",
    "truncated",
    "api_error",
]


def load_cells(results_dir: Path) -> dict[tuple[str, str], dict]:
    cells: dict[tuple[str, str], dict] = {}
    for summary_path in sorted(results_dir.glob("*/*/summary.json")):
        model = summary_path.parent.parent.name
        config = summary_path.parent.name
        cells[(model, config)] = json.loads(summary_path.read_text())
    return cells


def sort_key(key: tuple[str, str]) -> tuple[str, int]:
    model, config = key
    order = CONFIG_ORDER.index(config) if config in CONFIG_ORDER else len(CONFIG_ORDER)
    return model, order


def md_table(header: list[str], rows: list[list[str]]) -> str:
    sep = ["---"] * len(header)
    lines = ["| " + " | ".join(header) + " |", "| " + " | ".join(sep) + " |"]
    lines += ["| " + " | ".join(str(c) for c in row) + " |" for row in rows]
    return "\n".join(lines)


def pct(value: float) -> str:
    return f"{value * 100:.1f}%"


def delta(value: float, base: float) -> str:
    if base is None:
        return "-"
    diff = (value - base) * 100
    return f"{diff:+.1f}" if abs(diff) >= 0.05 else "0.0"


def headline_table(cells: dict) -> str:
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        summary = cells[key]
        reference = REFERENCE_OF.get(config)
        base = cells.get((model, reference)) if reference else None
        base_pass = base["pass_rate"] if base else None
        base_compile = base["compile_rate"] if base else None
        rows.append([
            model,
            CONFIG_LABEL.get(config, config),
            f"{summary['passed']}/{summary['total']}",
            pct(summary["pass_rate"]),
            delta(summary["pass_rate"], base_pass) if base_pass is not None else "—",
            pct(summary["compile_rate"]),
            delta(summary["compile_rate"], base_compile) if base_compile is not None else "—",
        ])
    return md_table(
        ["model", "configuration", "passed", "pass@1", "Δpp", "syntax OK", "Δpp"], rows
    )


def cost_table(cells: dict) -> str:
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        s = cells[key]
        solved = s["passed"] or 1
        problem_seconds = sum(r["wall_seconds"] for r in s["results"])
        rows.append([
            model,
            CONFIG_LABEL.get(config, config),
            f"{problem_seconds / 3600:.2f}",
            f"{s['wall_seconds_mean']:.1f}",
            f"{s['llm_calls'] / s['total']:.2f}" if s["total"] else "-",
            f"{s['prompt_tokens']:,}",
            f"{s['completion_tokens']:,}",
            f"{s.get('reasoning_tokens', 0):,}",
            f"{s['total_tokens']:,}",
            f"{s['total_tokens'] / s['total']:,.0f}" if s["total"] else "-",
            f"{s['total_tokens'] / solved:,.0f}",
        ])
    return md_table(
        [
            "model", "configuration", "compute (problem-hours)", "s/problem",
            "LLM calls/problem",
            "prompt tok", "completion tok", "of which reasoning", "total tok",
            "tok/problem", "tok/solved",
        ],
        rows,
    )


def tool_table(cells: dict) -> str:
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        s = cells[key]
        results = s["results"]
        total = s["total"] or 1
        used_compiler = sum(1 for r in results if r["compile_calls"] > 0)
        used_rag = sum(1 for r in results if r["rag_calls"] > 0)
        unfinished = sum(1 for r in results if not r["finished"])
        rows.append([
            model,
            CONFIG_LABEL.get(config, config),
            f"{sum(r['iterations'] for r in results) / total:.2f}",
            f"{used_compiler}/{s['total']}",
            f"{s['compile_calls'] / total:.2f}",
            f"{used_rag}/{s['total']}",
            f"{s['rag_calls'] / total:.2f}",
            unfinished,
        ])
    return md_table(
        [
            "model", "configuration", "iters/problem", "problems using compiler",
            "compile calls/problem", "problems using RAG", "RAG calls/problem",
            "unfinished",
        ],
        rows,
    )


def outcome_table(cells: dict) -> str:
    present = [
        o for o in OUTCOME_ORDER
        if any(s["outcomes"].get(o) for s in cells.values())
    ]
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        s = cells[key]
        rows.append(
            [model, CONFIG_LABEL.get(config, config)]
            + [s["outcomes"].get(o, 0) for o in present]
        )
    return md_table(["model", "configuration"] + present, rows)


def error_kind_table(cells: dict) -> str:
    kinds = sorted({k for s in cells.values() for k in s["error_kinds"]})
    if not kinds:
        return "_No compile errors were observed in any configuration._"
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        s = cells[key]
        rows.append(
            [model, CONFIG_LABEL.get(config, config)]
            + [s["error_kinds"].get(k, 0) for k in kinds]
            + [sum(s["error_kinds"].values())]
        )
    return md_table(["model", "configuration"] + kinds + ["total"], rows)


def topic_table(cells: dict) -> str:
    topics = sorted({t for s in cells.values() for t in s["topics"]})
    rows = []
    for key in sorted(cells, key=sort_key):
        model, config = key
        s = cells[key]
        row = [model, CONFIG_LABEL.get(config, config)]
        for topic in topics:
            bucket = s["topics"].get(topic)
            row.append(
                f"{bucket['passed']}/{bucket['total']}" if bucket else "-"
            )
        rows.append(row)
    return md_table(["model", "configuration"] + topics, rows)


def flip_table(cells: dict) -> str:
    rows = []
    models = sorted({m for m, _ in cells})
    for model in models:
        base = cells.get((model, "baseline")) or cells.get((model, "fix_oneshot"))
        if not base:
            continue
        base_name = base["meta"]["config"]
        base_pass = {r["problem"]: r["passed"] for r in base["results"]}
        for config in [c for c, ref in REFERENCE_OF.items() if ref == base_name]:
            cell = cells.get((model, config))
            if not cell:
                continue
            gained = [
                r["problem"] for r in cell["results"]
                if r["passed"] and not base_pass.get(r["problem"], 0)
            ]
            lost = [
                r["problem"] for r in cell["results"]
                if not r["passed"] and base_pass.get(r["problem"], 0)
            ]
            rows.append([
                model, CONFIG_LABEL[config], len(gained), len(lost),
                f"{len(gained) - len(lost):+d}",
            ])
    return md_table(["model", "configuration", "newly passing", "newly failing", "net"], rows)


def flip_detail(cells: dict) -> str:
    lines = []
    models = sorted({m for m, _ in cells})
    for model in models:
        base = cells.get((model, "baseline")) or cells.get((model, "fix_oneshot"))
        if not base:
            continue
        base_name = base["meta"]["config"]
        base_pass = {r["problem"]: r["passed"] for r in base["results"]}
        for config in [c for c, ref in REFERENCE_OF.items() if ref == base_name]:
            cell = cells.get((model, config))
            if not cell:
                continue
            gained = sorted(
                r["problem"] for r in cell["results"]
                if r["passed"] and not base_pass.get(r["problem"], 0)
            )
            lost = sorted(
                r["problem"] for r in cell["results"]
                if not r["passed"] and base_pass.get(r["problem"], 0)
            )
            lines.append(f"### {model} — {CONFIG_LABEL[config]} vs baseline\n")
            lines.append(f"**Newly passing ({len(gained)}):** "
                         + (", ".join(f"`{p}`" for p in gained) or "_none_"))
            lines.append("")
            lines.append(f"**Newly failing ({len(lost)}):** "
                         + (", ".join(f"`{p}`" for p in lost) or "_none_"))
            lines.append("")
    return "\n".join(lines)


def write_csvs(cells: dict, details: Path) -> None:
    metric_fields = [
        "model", "config", "total", "passed", "pass_rate", "compiled", "compile_rate",
        "wall_seconds_total", "wall_seconds_mean", "llm_calls", "prompt_tokens",
        "completion_tokens", "total_tokens", "compile_calls", "rag_calls",
    ]
    with (details / "metrics.csv").open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=metric_fields)
        writer.writeheader()
        for (model, config) in sorted(cells, key=sort_key):
            s = cells[(model, config)]
            writer.writerow(
                {"model": model, "config": config}
                | {k: s[k] for k in metric_fields if k in s}
            )

    problem_fields = [
        "model", "config", "problem", "topic", "outcome", "passed", "compiled",
        "error_kind", "mismatches", "iterations", "finished", "tool_calls",
        "compile_calls", "rag_calls", "llm_calls", "prompt_tokens",
        "completion_tokens", "total_tokens", "wall_seconds", "agent_error",
    ]
    with (details / "per_problem.csv").open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=problem_fields, extrasaction="ignore")
        writer.writeheader()
        for (model, config) in sorted(cells, key=sort_key):
            for record in cells[(model, config)]["results"]:
                writer.writerow({"model": model, "config": config} | record)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-dir", type=Path, default=EXP_DIR / "results")
    parser.add_argument("--details-dir", type=Path, default=EXP_DIR / "acceptance" / "details")
    args = parser.parse_args()

    cells = load_cells(args.results_dir)
    if not cells:
        print(f"no summary.json under {args.results_dir}")
        return 1
    args.details_dir.mkdir(parents=True, exist_ok=True)
    write_csvs(cells, args.details_dir)

    sections = [
        ("Headline: accuracy", headline_table(cells)),
        ("Cost: time and tokens", cost_table(cells)),
        ("Tool usage", tool_table(cells)),
        ("Outcome distribution", outcome_table(cells)),
        ("Compile-error kinds", error_kind_table(cells)),
        ("Pass rate by problem topic", topic_table(cells)),
        ("Problems flipped relative to baseline", flip_table(cells)),
    ]
    tables = "\n\n".join(f"## {title}\n\n{body}" for title, body in sections)
    (args.details_dir / "tables.md").write_text(
        "# Generated tables\n\n"
        "Regenerate with `python3 analysis/aggregate.py`.\n\n" + tables + "\n"
    )
    (args.details_dir / "flipped_problems.md").write_text(
        "# Problems that changed verdict relative to the baseline\n\n" + flip_detail(cells) + "\n"
    )
    print(tables)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
