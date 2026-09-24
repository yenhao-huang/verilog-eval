# Reproducing the experiment

Every command below is run from the repository root unless stated otherwise.
Expect roughly **4–6 hours** of wall-clock time for the full 6-cell matrix on a
single GB10, most of it model inference.

---

## 0. What you need

| Requirement | Used for | Check |
| --- | --- | --- |
| Icarus Verilog (`iverilog`, `vvp`) | compiling and simulating candidates | `iverilog -V \| head -1` |
| Python 3.11+ | the harness (standard library only, no pip install) | `python3 -V` |
| Docker with the NVIDIA runtime | serving both models | `docker run --rm --gpus all ubuntu:24.04 nvidia-smi` |
| ~128 GB unified memory GPU | one model at a time | `nvidia-smi` |
| The two checkpoints | see below | |

Checkpoints on this box:

```
/workspace/models/Inferact-Qwen3.8-Flash-Next-NVFP4/          # qwen3.8-flash-next
/workspace/models/unsloth-gemma-4-26B-A4B-it-GGUF/            # gemma-4-26B-A4B-it, Q4_K_XL
```

Docker images:

```
qwen38-flash-dgx:latest        # vLLM + the Qwen3.8-Flash-Next plugin stack; also used
                               # as the CUDA toolchain for the llama.cpp build
```

> **Only one model fits on the GPU at a time.** Run the qwen cells, stop the
> qwen server, then run the gemma cells.

---

## 1. Get the code

```bash
git clone https://github.com/yenhao-huang/verilog-eval.git
cd verilog-eval
git checkout experiment/rtl-fix-react-rag
cd exp/rtl_fix
```

Sanity-check the dataset is present:

```bash
wc -l ../../dataset_spec-to-rtl/problems.txt   # 156
```

---

## 2. Serve qwen3.8-flash-next

```bash
scripts/serve_qwen38_next.sh
```

This wraps the box's own launcher (`/workspace/vllm/serve-qwen38-flash-next.sh`),
which starts a container named `qwen38-flash` publishing port **18300**, with
`--max-num-seqs 8`, `--enable-auto-tool-choice` and
`--tool-call-parser qwen3_coder`. Native tool calling is required — the ReAct
configurations drive the agent through OpenAI-style `tool_calls`.

First boot loads ~76 GiB of weights and takes 8–13 minutes. Wait for:

```bash
curl -s http://localhost:18300/v1/models | python3 -m json.tool
```

### Smoke test before committing to the full run

```bash
scripts/run_cell.sh qwen38_next react_compiler_rag \
  --problems Prob001_zero --jobs 1 \
  --out-dir /tmp/rtlfix-smoke        # always send partial runs elsewhere
python3 -c "
import json; t=json.load(open('/tmp/rtlfix-smoke/problems/Prob001_zero/transcript.json'))
print([m['role'] for m in t])"
```

The transcript must contain a `tool` role. If it does not, the endpoint is not
emitting tool calls and every ReAct cell will silently degrade to the baseline.

---

## 3. What the 18 cells are, and the command for each

Every cell is one `(task, configuration, budget)` combination. The runner takes
all three explicitly, so any cell can be reproduced on its own.

| # | task | configuration | budget | command |
| --- | --- | --- | --- | --- |
| 1 | generate | `baseline` | 8192 | `scripts/run_cell.sh qwen38_next baseline --max-tokens 8192` |
| 2 | generate | `react_compiler` | 8192 | `scripts/run_cell.sh qwen38_next react_compiler --max-tokens 8192` |
| 3 | generate | `react_compiler_rag` | 8192 | `scripts/run_cell.sh qwen38_next react_compiler_rag --max-tokens 8192` |
| 4 | repair | `fix_oneshot` | 8192 | see **repair cells** below |
| 5 | repair | `fix_react_compiler` | 8192 | " |
| 6 | repair | `fix_react_compiler_rag` | 8192 | " |
| 7–12 | the same six for `gemma4_26b_a4b` | | 8192 | swap the model label |
| 13–18 | the same six for qwen | | **30000** | see **budget ablation** below |

> **Running a subset safely.** A run without `--resume` rewrites
> `summary.json` with only the problems it covered. The runner refuses when
> that would shrink a completed cell, but the habit to keep is: pass
> `--out-dir` to a scratch path whenever you run part of a cell, and
> `--resume` whenever you mean to extend one.

### 3.1 Generation cells (VerilogEval-v2, spec-to-rtl, 156 problems)

One configuration at a time:

```bash
scripts/run_cell.sh qwen38_next baseline           --jobs 12
scripts/run_cell.sh qwen38_next react_compiler     --jobs 12
scripts/run_cell.sh qwen38_next react_compiler_rag --jobs 12
```

Or all three in order:

```bash
scripts/run_model_sweep.sh qwen38_next --jobs 12
```

Writes to `results/qwen38_next/<config>/`.

**What differs between the three** — only the system prompt and the tool list;
the dataset, grader and sampling parameters are identical:

| config | system prompt | tools offered |
| --- | --- | --- |
| `baseline` | `prompts/system_generate.txt` | none |
| `react_compiler` | `prompts/react_system_runtime_norag.txt` | `verilog_compiler` |
| `react_compiler_rag` | `prompts/react_system_runtime.txt` | `verilog_compiler`, `error_lookup` |

### 3.2 Repair cells (VerilogEval-syntax, 158 problems)

This task needs RTLFixer's dataset, which is fetched rather than vendored:

```bash
scripts/fetch_syntax_dataset.sh     # 174 rows; the runner skips the 16 that
                                    # already compile under this iverilog
```

One configuration at a time — note `--task repair`, and that these configs have
their own names:

```bash
scripts/run_cell.sh qwen38_next fix_oneshot            --task repair --jobs 12
scripts/run_cell.sh qwen38_next fix_react_compiler     --task repair --jobs 12
scripts/run_cell.sh qwen38_next fix_react_compiler_rag --task repair --jobs 12
```

Or all three:

```bash
scripts/run_repair_sweep.sh qwen38_next --jobs 12
```

Writes to `results_repair/qwen38_next/<config>/`.

| config | system prompt | tools offered |
| --- | --- | --- |
| `fix_oneshot` | `prompts/fix_system_oneshot.txt` | none |
| `fix_react_compiler` | `prompts/fix_system_react_norag.txt` | `verilog_compiler` |
| `fix_react_compiler_rag` | `prompts/fix_system_react.txt` | `verilog_compiler`, `error_lookup` |

`fix_oneshot` is the paper's Figure 2(a) one-shot repair: the model is handed a
broken implementation plus the compiler log, in one turn, with no tools.

### 3.3 The budget ablation (the headline result)

The six cells above all share `max_tokens=8192`, which is **not** a fair
comparison: a ReAct configuration gets a fresh 8192 tokens on each of up to ten
iterations, a single-call configuration gets one. Re-running all six at 30000
is what separates "the tool helped" from "it was allowed to finish".

The server's context limit must clear the budget first:

```bash
docker stop qwen38-flash
CTX=48000 SEQS=24 PORT=18300 /workspace/vllm/serve-qwen38-flash-next.sh
```

Then all six:

```bash
scripts/run_budget_ablation.sh
```

Or a subset, via `CELLS` (`task:config` pairs):

```bash
CELLS="generate:react_compiler repair:fix_react_compiler" \
  scripts/run_budget_ablation.sh
```

Or one cell by hand, which is what the script does per cell:

```bash
python3 src/rtlfix/runner.py \
  --repo-root ../.. \
  --out-dir results_budget30k/qwen38_next/react_compiler \
  --task generate --config react_compiler \
  --model-label qwen38_next \
  --base-url http://localhost:18300/v1 --model-name qwen3.8-flash-next \
  --max-tokens 30000 --timeout 7200 --jobs 12 --resume
```

Writes to `results_budget30k/qwen38_next/<config>/`, leaving the 8192 runs
intact as the control. Budget the whole ablation at 10–14 hours: token volume
roughly doubles, and the long tail runs at low concurrency.

`--timeout 7200` matters — a single 30k-token generation can take ~50 minutes
once the batch is full, and the default would abort it and record an
`api_error`.

---

## 4. Build a CUDA llama.cpp server for gemma

gemma-4-26B-A4B is only available here as a GGUF, and vLLM refuses it:

```
ValueError: GGUF model with architecture gemma4 is not supported yet.
```

The host's `/usr/local/bin/llama-server` is a CPU-only build
(`llama-server --list-devices` reports no devices), so build a CUDA one. The
host has no `nvcc`, so the build runs inside the CUDA image that already serves
qwen:

```bash
scripts/build_llama_cpp_cuda.sh
```

Notes:

* `-DCMAKE_CUDA_ARCHITECTURES=121` targets the GB10.
* The image ships only the CUDA driver *stub*, so the build passes
  `-L/usr/local/cuda/lib64/stubs -lcuda`; without it `libggml-cuda.so` fails to
  link with `undefined reference to 'cuGetErrorString'`.
* Output lands in `/workspace/build-llamacpp/out/build/bin/llama-server`.

Takes about 10 minutes on 20 cores.

---

## 5. Swap models and run the gemma cells

Free the GPU first:

```bash
docker stop qwen38-flash
```

Then:

```bash
scripts/serve_gemma4_26b.sh          # container gemma4-26b on port 18400
scripts/run_model_sweep.sh gemma4_26b_a4b --jobs 4
```

`serve_gemma4_26b.sh` runs the CUDA `llama-server` with `--jinja` (needed for
the gemma tool-call template), `--parallel 4` and a 32k context per slot.

Run the same smoke test as in step 2 against port 18400 before the full sweep.

---

## 6. Aggregate

```bash
python3 analysis/aggregate.py
```

By default this reads the generation cells. The repair and ablation results
live in their own trees, so each needs its own invocation:

```bash
python3 analysis/aggregate.py                                    # results/
python3 analysis/aggregate.py --results-dir results_repair \
        --details-dir acceptance/details/repair                  # results_repair/
python3 analysis/aggregate.py --results-dir results_budget30k \
        --details-dir acceptance/details/budget30k               # results_budget30k/
```

Each reads every `<model>/<config>/summary.json` under its tree and writes:

```
acceptance/details/metrics.csv           one row per (model, config)
acceptance/details/per_problem.csv       one row per (model, config, problem)
acceptance/details/tables.md             every table in reports.md
acceptance/details/flipped_problems.md   which problems changed verdict
```

`acceptance/reports.md` is written by hand from `tables.md`.

---

## 7. What gets written per problem

```
results/<model>/<config>/
├── summary.json                     aggregate metrics + every per-problem record
└── problems/<Prob…>/
    ├── transcript.json              full message list, including tool calls
    ├── TopModule.sv                 the code that was graded
    ├── grade.log                    iverilog + vvp output from grading
    └── record.json                  that problem's metrics row
```

---

## Fixed experiment parameters

| Parameter | Value | Why |
| --- | --- | --- |
| temperature | 0.4 | RTLFixer §4.1: "we set the sampling temperature to 0.4" |
| max ReAct iterations | 10 | RTLFixer §4.1: "a maximum of 10 iterations of Thought-Action-Observation" |
| max tokens per call | 8192 | **deviation.** RTLFixer used 2048 with GPT-3.5, which has no reasoning tokens. Both models here spend part of that budget on reasoning, and at 2048 qwen returned an empty `content` (`finish_reason: "length"`) on ~10% of problems — a truncation artefact that would have been scored as a model failure. `summary.json` reports `truncated_problems` so the remaining truncation is visible. |
| top_p | 1.0 | matches RTLFixer's `ChatOpenAI(top_p=1.0)` |
| samples per problem | 1 | pass@1 |
| generation benchmark | **VerilogEval-v2 (spec-to-rtl)**, `dataset_spec-to-rtl`, 156 problems | the repo's own dataset |
| repair benchmark | **VerilogEval-syntax**, 158 of RTLFixer's 174 rows (derived from VerilogEval-v1 code-completion) | the set the paper's Table 1 is measured on |

Because the runs are single-sample at temperature 0.4, small differences
between configurations are within sampling noise. Treat differences of a
couple of problems as inconclusive; the report says which ones are large
enough to matter.
