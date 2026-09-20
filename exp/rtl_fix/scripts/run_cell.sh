#!/usr/bin/env bash
# Run one (model, configuration) cell of the A/B matrix.
#
#   scripts/run_cell.sh <model-label> <config> [extra runner args...]
#
# The endpoint is selected from the model label; override with BASE_URL and
# MODEL_NAME if you serve the models somewhere else.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$EXP_DIR/../.." && pwd)"

MODEL_LABEL="${1:?usage: run_cell.sh <model-label> <config> [args...]}"
CONFIG="${2:?usage: run_cell.sh <model-label> <config> [args...]}"
shift 2

case "$MODEL_LABEL" in
  qwen38_next)
    DEFAULT_URL="http://localhost:18300/v1"
    DEFAULT_MODEL="qwen3.8-flash-next"
    ;;
  gemma4_26b_a4b)
    DEFAULT_URL="http://localhost:18400/v1"
    DEFAULT_MODEL="gemma-4-26b-a4b-it"
    ;;
  *)
    DEFAULT_URL=""
    DEFAULT_MODEL=""
    ;;
esac

BASE_URL="${BASE_URL:-$DEFAULT_URL}"
MODEL_NAME="${MODEL_NAME:-$DEFAULT_MODEL}"
JOBS="${JOBS:-4}"
OUT_DIR="${OUT_DIR:-$EXP_DIR/results/$MODEL_LABEL/$CONFIG}"

exec python3 "$EXP_DIR/src/rtlfix/runner.py" \
  --repo-root "$REPO_ROOT" \
  --out-dir "$OUT_DIR" \
  --config "$CONFIG" \
  --model-label "$MODEL_LABEL" \
  --base-url "$BASE_URL" \
  --model-name "$MODEL_NAME" \
  --jobs "$JOBS" \
  "$@"
