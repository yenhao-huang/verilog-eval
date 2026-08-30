# qwen38_next VerilogEval

The default command runs only the first `spec-to-rtl` problem:

```bash
exp/qwen38_next/qwen38_next.sh one
```

After the smoke test succeeds, run all problems:

```bash
exp/qwen38_next/qwen38_next.sh all --jobs 4
```

Increase `--jobs` only when the vLLM server has enough concurrent-sequence
capacity. The equivalent environment variable is `JOBS=4`.

Defaults can be overridden with environment variables:

```bash
VLLM_BASE_URL=http://192.168.1.82:18300/v1 \
MODEL_NAME=qwen3.8-flash-next \
RESULTS_DIR=exp/qwen38_next/results \
exp/qwen38_next/qwen38_next.sh one Prob001_zero
```

Each problem directory contains the prompt, raw API response, extracted Verilog,
and the Icarus Verilog log. Aggregate results are written to `score.csv` and
`score.json` after every problem, so an interrupted full run retains its partial
score.
