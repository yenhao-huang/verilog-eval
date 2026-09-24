#!/usr/bin/env bash
# Build a CUDA-enabled llama.cpp server for the GB10 (sm_121).
#
# The box's preinstalled /usr/local/bin/llama-server is a CPU-only build, and
# vLLM cannot load the gemma4 GGUF ("GGUF model with architecture gemma4 is not
# supported yet"), so gemma-4-26B-A4B is served through llama.cpp instead.
# The build runs inside the CUDA image that already serves qwen, because the
# host has no nvcc.
set -euo pipefail

WORKDIR="${WORKDIR:-/workspace/build-llamacpp}"
IMAGE="${IMAGE:-qwen38-flash-dgx:latest}"
CUDA_ARCH="${CUDA_ARCH:-121}"
REF="${REF:-master}"

mkdir -p "$WORKDIR/out"

if [ ! -d "$WORKDIR/src/.git" ]; then
  git clone --depth 1 --branch "$REF" https://github.com/ggml-org/llama.cpp.git "$WORKDIR/src"
fi

cat > "$WORKDIR/build.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
if ! command -v cmake >/dev/null; then
  apt-get update -qq && apt-get install -y -qq cmake git >/dev/null
fi
git config --global --add safe.directory /src || true
cd /src
# The image ships only the libcuda stub, so the driver library must be named
# explicitly or libggml-cuda.so fails to link on cuGetErrorString.
cmake -B /out/build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCH} \\
  -DLLAMA_CURL=OFF -DGGML_NATIVE=ON -DCMAKE_BUILD_TYPE=Release \\
  -DLLAMA_BUILD_TESTS=OFF -DLLAMA_BUILD_EXAMPLES=OFF \\
  -DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/cuda/lib64/stubs -lcuda" \\
  -DCMAKE_SHARED_LINKER_FLAGS="-L/usr/local/cuda/lib64/stubs -lcuda"
cmake --build /out/build --config Release -j "\$(nproc)" --target llama-server
echo BUILD_OK
EOF
chmod +x "$WORKDIR/build.sh"

docker rm -f llamacpp-build >/dev/null 2>&1 || true
docker run --rm --name llamacpp-build --entrypoint bash \
  -v "$WORKDIR/src:/src" -v "$WORKDIR/out:/out" -v "$WORKDIR/build.sh:/build.sh:ro" \
  "$IMAGE" /build.sh

echo ">> built $WORKDIR/out/build/bin/llama-server"
