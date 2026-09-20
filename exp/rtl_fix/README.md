# exp/rtl_fix — quantifying RTLFixer's ReAct + RAG on VerilogEval

A local replication of the two ideas in
[RTLFixer (arXiv:2311.16543)](https://arxiv.org/abs/2311.16543): ReAct
prompting with a compiler in the loop, and RAG over a curated
compiler-error → expert-guidance database.

The question this experiment answers: **on the VerilogEval `spec-to-rtl`
benchmark, how much does each of those two additions actually buy, for two
locally served open models?**

## Layout

```
exp/rtl_fix/
├── docs/
│   ├── goals/goals.md         the request this experiment implements
│   └── assets/                the RTLFixer paper
├── prompts/                   prompts transcribed from the paper (+ SOURCES.md)
├── knowledge/                 the RAG expert-guidance database
├── src/rtlfix/                the agent framework
│   ├── llm.py                 OpenAI-compatible client + token accounting
│   ├── compiler.py            iverilog: agent-facing syntax check, offline grader
│   ├── rag.py                 exact-match retriever over knowledge/
│   ├── tools.py               the two tools and their JSON schemas
│   ├── extract.py             pulls a module out of free-form model output
│   ├── agent.py               one-shot baseline + the ReAct loop
│   ├── classify.py            outcome / error-kind / topic taxonomies
│   ├── dataset.py             VerilogEval spec-to-rtl accessors
│   └── runner.py              CLI driver for one (model, config) cell
├── scripts/                   model serving and experiment entry points
├── analysis/aggregate.py      results → acceptance tables
├── results/<model>/<config>/  raw per-problem artefacts and summary.json
└── acceptance/                reports.md, reproduce.md, details/
```

## The three configurations

| config | system prompt | tools | corresponds to |
| --- | --- | --- | --- |
| `baseline` | `prompts/system_generate.txt` | none | plain single-turn generation |
| `react_compiler` | `prompts/react_system_runtime_norag.txt` | `verilog_compiler` | RTLFixer ReAct without RAG |
| `react_compiler_rag` | `prompts/react_system_runtime.txt` | `verilog_compiler`, `error_lookup` | RTLFixer ReAct with RAG |

The agent never sees the testbench: its `verilog_compiler` tool compiles the
candidate module on its own. Grading links the candidate against the
VerilogEval testbench and reference in a separate, offline step.

## Running it

See `acceptance/reproduce.md` for the full step-by-step procedure. The short
version:

```bash
# one cell
scripts/run_cell.sh qwen38_next react_compiler_rag --jobs 4

# all three configurations for one model
scripts/run_model_sweep.sh qwen38_next --jobs 4

# rebuild the tables
python3 analysis/aggregate.py
```

## Results

`acceptance/reports.md`.
