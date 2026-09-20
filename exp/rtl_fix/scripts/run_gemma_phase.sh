#!/usr/bin/env bash
# Hand the GPU from qwen to gemma and run gemma's four sweeps.
#
# Only one model fits on the GB10, so this waits for any running qwen sweep to
# finish, stops the qwen server, brings gemma up, and refuses to start the
# sweeps unless a smoke test proves the endpoint actually emits tool calls —
# without them every ReAct cell would silently degrade into the baseline.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MODEL_LABEL="${MODEL_LABEL:-gemma4_26b_a4b}"
PORT="${PORT:-18400}"
JOBS="${JOBS:-8}"   # keep in step with PARALLEL in serve_gemma4_26b.sh
SMOKE_DIR="${SMOKE_DIR:-/tmp/rtlfix-gemma-smoke}"

echo "=== waiting for any running qwen sweep ==="
while pgrep -f "rtlfix/runner.py.*qwen38_next" >/dev/null 2>&1; do sleep 60; done
echo ">> qwen sweeps finished at $(date -u +%H:%M:%S)"

echo "=== freeing the GPU ==="
docker stop qwen38-flash >/dev/null 2>&1 || true
sleep 20

echo "=== starting gemma ==="
PORT="$PORT" "$SCRIPT_DIR/serve_gemma4_26b.sh"

echo "=== smoke test: does this endpoint emit tool calls? ==="
rm -rf "$SMOKE_DIR"
"$SCRIPT_DIR/run_cell.sh" "$MODEL_LABEL" react_compiler \
  --problems Prob001_zero --jobs 1 --out-dir "$SMOKE_DIR" || true

if ! python3 - "$SMOKE_DIR/problems/Prob001_zero/transcript.json" <<'PY'
import json, sys
try:
    transcript = json.load(open(sys.argv[1]))
except Exception as exc:
    print(f"!! could not read transcript: {exc}")
    raise SystemExit(1)
roles = [m["role"] for m in transcript]
print(f">> roles: {roles}")
raise SystemExit(0 if "tool" in roles else 1)
PY
then
  echo "!! gemma did not emit tool calls — stopping before the sweeps." >&2
  echo "!! inspect: docker logs gemma4-26b; $SMOKE_DIR/problems/Prob001_zero/transcript.json" >&2
  exit 1
fi

echo "=== gemma generation sweep ==="
"$SCRIPT_DIR/run_model_sweep.sh" "$MODEL_LABEL" --jobs "$JOBS"

echo "=== gemma repair sweep ==="
"$SCRIPT_DIR/run_repair_sweep.sh" "$MODEL_LABEL" --jobs "$JOBS"

echo "=== gemma phase complete at $(date -u +%H:%M:%S) ==="
