# The budget ablation: ReAct's gain on generation was an artefact

## Why this was run

Every cell in the main experiment used `max_tokens=8192`. At that budget 17–22%
of problems hit the cap and produced nothing, and the ReAct configurations
truncated far less often than the baselines. Two explanations fit equally well:

1. **The paper's claim.** Compiler feedback repairs syntax the model could not
   fix alone.
2. **A budget artefact.** ReAct's turn structure hands the model a *fresh* 8192
   tokens on every iteration — up to ten of them. The baseline gets one. ReAct
   may simply be finishing where the baseline was cut off.

The main report could not distinguish these. This ablation does: re-run the
single-call configurations with a budget large enough to make truncation
disappear, and see whether the baseline catches up.

Setup: same model, same prompts, same temperature, `--max-model-len 48000`,
`--max-tokens 30000`. Results in `results_budget30k/`; the 8192 runs are the
control and were not touched.

## Result — VerilogEval-v2 (spec-to-rtl), qwen3.8-next

| configuration | pass@1 | syntax OK | truncated | compile_error | completion tok | compute (problem-h) |
| --- | --- | --- | --- | --- | --- | --- |
| baseline @8192 | 118/156 (75.6%) | 79.5% | 27 | 5 | 443,870 | 15.74 |
| ReAct + compiler @8192 | 131/156 (84.0%) | 89.1% | 14 | 3 | 361,053 | 10.87 |
| ReAct + compiler + RAG @8192 | 127/156 (81.4%) | 88.5% | 14 | 4 | 350,666 | 10.31 |
| **baseline @30000** | **135/156 (86.5%)** | **92.3%** | **5** | 7 | 779,540 | 21.03 |

**Explanation 2 is correct.** Given enough room to finish, the plain baseline —
no compiler tool, no RAG, no iteration — beats every ReAct configuration on both
accuracy (86.5% vs 84.0%) and syntax (92.3% vs 89.1%).

The `compile_error` column makes the point sharper still: it goes *up*, 5 → 7,
when the baseline is allowed to finish. The extra answers it now produces are
not uniformly clean. Whatever the compiler tool was doing, it was not
suppressing syntax errors — there were only 3–7 of them in 156 problems in any
configuration.

## What survives

ReAct is not worthless here. Look at the cost column:

| | accuracy | compute | completion tokens |
| --- | --- | --- | --- |
| ReAct + compiler @8192 | 84.0% | **10.87 h** | **361k** |
| baseline @30000 | 86.5% | 21.03 h | 780k |

ReAct reaches within 2.5pp of the big-budget baseline for **half the compute and
half the tokens**. That is a real, useful property — but it is an *efficiency*
result, not a *capability* result, and it is not the result the paper claims.

The honest summary:

> ReAct with a compiler tool does not make qwen3.8-next better at Verilog. It
> makes it cheaper. Chopping one long generation into short tool-terminated
> turns stops the model over-reasoning, which recovers most of what a 3.7x
> larger budget would buy, at a fraction of the cost.

## Consequence for the main report

Finding 2.1 of `reports.md` said the gain came from truncation rather than
syntax repair. That was right as far as it went, but it stopped one step short:
it still treated the truncation reduction as something ReAct *earned*. It did
not. The baseline reaches the same place with nothing but a larger budget, and
overtakes it.

Every "ReAct helps" number in the main tables for the generation benchmark is
therefore an artefact of the shared 8192 budget, and should be read as a
statement about cost-efficiency at a fixed budget, not about capability.

## Still open

The repair benchmark (`fix_oneshot @30000`) is the other half of this ablation
and was running when this file was written. If it reproduces the same pattern,
the same correction applies to the repair tables. The gemma cells were not
re-run at all — that model's ReAct results were already neutral-to-negative
after correcting for the harness fallback, so a budget correction can only move
them further in the same direction.
