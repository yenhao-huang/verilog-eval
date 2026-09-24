#!/usr/bin/env bash
# Run all three configurations for one model, in increasing cost order.
#
#   scripts/run_model_sweep.sh <model-label> [extra runner args...]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_LABEL="${1:?usage: run_model_sweep.sh <model-label> [args...]}"
shift || true

for config in baseline react_compiler react_compiler_rag; do
  echo "=== $MODEL_LABEL / $config ==="
  "$SCRIPT_DIR/run_cell.sh" "$MODEL_LABEL" "$config" --resume "$@"
done
