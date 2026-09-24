#!/usr/bin/env bash
# Run all three repair configurations for one model on RTLFixer's
# VerilogEval-syntax dataset (the paper's Table 1 setting).
#
#   scripts/run_repair_sweep.sh <model-label> [extra runner args...]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MODEL_LABEL="${1:?usage: run_repair_sweep.sh <model-label> [args...]}"
shift || true

[ -s "$EXP_DIR/data/verilogeval-syntax.jsonl" ] || "$SCRIPT_DIR/fetch_syntax_dataset.sh"

for config in fix_oneshot fix_react_compiler fix_react_compiler_rag; do
  echo "=== $MODEL_LABEL / $config ==="
  OUT_DIR="$EXP_DIR/results_repair/$MODEL_LABEL/$config" \
    "$SCRIPT_DIR/run_cell.sh" "$MODEL_LABEL" "$config" --task repair --resume "$@"
done
