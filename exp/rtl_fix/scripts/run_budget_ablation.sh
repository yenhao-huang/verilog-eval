#!/usr/bin/env bash
# Completion-budget ablation.
#
# The main experiment ran every cell at max_tokens=8192, where 17-22% of
# problems hit the cap and produced nothing. That makes the headline
# comparison ambiguous: ReAct might be winning because compiler feedback
# repairs syntax (the paper's claim), or merely because splitting the work
# across turns gives the model more room to finish.
#
# This re-runs only the single-call configurations at a budget large enough
# to drive truncation to ~zero, so the two explanations can be told apart.
# If one-shot catches up to ReAct once it is allowed to finish, the paper's
# mechanism is not what produced our gains.
#
# Results go to results_budget30k/ — the 8192 runs are the control and must
# not be overwritten.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$EXP_DIR/../.." && pwd)"

MODEL_LABEL="${MODEL_LABEL:-qwen38_next}"
BASE_URL="${BASE_URL:-http://localhost:18300/v1}"
MODEL_NAME="${MODEL_NAME:-qwen3.8-flash-next}"
MAX_TOKENS="${MAX_TOKENS:-30000}"
JOBS="${JOBS:-12}"
# A single 30k-token generation takes ~50 min at the per-request rate seen
# under this much concurrency, so the client timeout has to clear that.
TIMEOUT="${TIMEOUT:-7200}"
OUT_ROOT="${OUT_ROOT:-$EXP_DIR/results_budget30k}"

# All four qwen cells that the budget question touches. The ReAct cells matter
# as much as the single-call ones: comparing ReAct@8192 against baseline@30000
# is not like-for-like, so both arms have to be measured at the same budget
# before the comparison means anything.
CELLS="${CELLS:-generate:baseline repair:fix_oneshot generate:react_compiler repair:fix_react_compiler}"

for spec in $CELLS; do
  task="${spec%%:*}"
  config="${spec##*:}"
  echo "=== $MODEL_LABEL / $config @ max_tokens=$MAX_TOKENS ==="
  python3 "$EXP_DIR/src/rtlfix/runner.py" \
    --repo-root "$REPO_ROOT" \
    --out-dir "$OUT_ROOT/$MODEL_LABEL/$config" \
    --task "$task" \
    --config "$config" \
    --model-label "$MODEL_LABEL" \
    --base-url "$BASE_URL" \
    --model-name "$MODEL_NAME" \
    --max-tokens "$MAX_TOKENS" \
    --timeout "$TIMEOUT" \
    --jobs "$JOBS" \
    --resume
done

echo "=== budget ablation complete ==="
