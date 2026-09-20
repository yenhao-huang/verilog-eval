#!/usr/bin/env bash
# Serve unsloth/gemma-4-26B-A4B-it (Q4_K_XL GGUF) with the CUDA llama.cpp
# server built by build_llama_cpp_cuda.sh.
#
# vLLM cannot be used here: transformers rejects the checkpoint with
# "GGUF model with architecture gemma4 is not supported yet".
set -euo pipefail

NAME="${NAME:-gemma4-26b}"
IMAGE="${IMAGE:-qwen38-flash-dgx:latest}"
BUILD_DIR="${BUILD_DIR:-/workspace/build-llamacpp/out}"
MODEL_DIR="${MODEL_DIR:-/workspace/models/unsloth-gemma-4-26B-A4B-it-GGUF}"
MODEL_FILE="${MODEL_FILE:-gemma-4-26B-A4B-it-UD-Q4_K_XL.gguf}"
PORT="${PORT:-18400}"
CTX="${CTX:-16384}"
PARALLEL="${PARALLEL:-8}"
NGL="${NGL:-99}"
SERVED_NAME="${SERVED_NAME:-gemma-4-26b-a4b-it}"

[ -f "$MODEL_DIR/$MODEL_FILE" ] || { echo "!! no GGUF at $MODEL_DIR/$MODEL_FILE" >&2; exit 1; }
[ -x "$BUILD_DIR/build/bin/llama-server" ] || {
  echo "!! run scripts/build_llama_cpp_cuda.sh first" >&2; exit 1; }

docker rm -f "$NAME" >/dev/null 2>&1 || true
docker run -d --name "$NAME" --gpus all --ipc=host --shm-size 8g \
  -p "${PORT}:8000" \
  -v "$BUILD_DIR:/out:ro" \
  -v "$MODEL_DIR:/model:ro" \
  --entrypoint /out/build/bin/llama-server \
  "$IMAGE" \
    --model "/model/$MODEL_FILE" \
    --alias "$SERVED_NAME" \
    --host 0.0.0.0 --port 8000 \
    --n-gpu-layers "$NGL" \
    --ctx-size "$((CTX * PARALLEL))" \
    --parallel "$PARALLEL" \
    --jinja \
    --no-warmup

echo ">> $NAME starting on :$PORT (model '$SERVED_NAME')"
for _ in $(seq 1 120); do
  if curl -sf "http://localhost:${PORT}/v1/models" >/dev/null; then
    echo ">> ready"
    exit 0
  fi
  sleep 10
done
echo "!! server did not become ready in 20 minutes; docker logs $NAME" >&2
exit 1
