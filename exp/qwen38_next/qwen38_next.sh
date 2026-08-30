#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

export VLLM_BASE_URL="${VLLM_BASE_URL:-http://192.168.1.82:18300/v1}"
export MODEL_NAME="${MODEL_NAME:-qwen3.8-flash-next}"
export RESULTS_DIR="${RESULTS_DIR:-$SCRIPT_DIR/results}"

exec python3 "$SCRIPT_DIR/evaluate.py" --repo-root "$REPO_ROOT" "$@"
