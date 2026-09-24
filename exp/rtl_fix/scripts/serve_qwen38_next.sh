#!/usr/bin/env bash
# Serve Inferact-Qwen3.8-Flash-Next-NVFP4 with vLLM on the GB10 box.
#
# This is a thin wrapper around the box's own launcher
# (/workspace/vllm/serve-qwen38-flash-next.sh) so the experiment records exactly
# which settings produced the numbers in acceptance/reports.md.
set -euo pipefail

LAUNCHER="${LAUNCHER:-/workspace/vllm/serve-qwen38-flash-next.sh}"
PORT="${PORT:-18300}"

[ -x "$LAUNCHER" ] || { echo "!! launcher not found: $LAUNCHER" >&2; exit 1; }

PORT="$PORT" SEQS="${SEQS:-8}" CTX="${CTX:-262144}" "$LAUNCHER"

echo ">> waiting for http://localhost:${PORT}/v1/models"
for _ in $(seq 1 180); do
  if curl -sf "http://localhost:${PORT}/v1/models" >/dev/null; then
    echo ">> ready"
    exit 0
  fi
  sleep 10
done
echo "!! server did not become ready in 30 minutes" >&2
exit 1
