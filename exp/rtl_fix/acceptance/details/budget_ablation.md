# The budget ablation: all six qwen cells at two budgets

## Why this was run

The main matrix ran every configuration at `max_tokens=8192`. That is not a fair
fight: ReAct's turn structure hands the model a fresh 8192 tokens on each of up
to ten iterations, while a single-call configuration gets one. At 8192, 17–22%
of single-call problems hit the cap and produced nothing, so "ReAct truncates
less" could mean the tool helped — or merely that ReAct was allowed to finish.

The first version of this ablation re-ran only the *single-call* cells at 30000
and concluded the whole ReAct advantage was a budget artefact. **That conclusion
was wrong**, because it compared `baseline @30000` against `ReAct @8192` — still
not like-for-like. All six cells are now measured at both budgets.

Setup: qwen3.8-next, same prompts, same temperature, `--max-model-len 48000`.

## VerilogEval-v2 (spec-to-rtl generation, 156 problems)

| configuration | budget | pass@1 | syntax OK | truncated | compile err | completion tok | compute |
| --- | --- | --- | --- | --- | --- | --- | --- |
| baseline (no tools) | 8192 | 118/156 (75.6%) | 79.5% | 27 | 5 | 443,870 | 15.74 h |
| ReAct + compiler | 8192 | 131/156 (84.0%) | 89.1% | 14 | 3 | 361,053 | 10.87 h |
| ReAct + compiler + RAG | 8192 | 127/156 (81.4%) | 88.5% | 14 | 4 | 350,666 | 10.31 h |
| baseline (no tools) | 30000 | 135/156 (86.5%) | 92.3% | 5 | 7 | 779,540 | 21.03 h |
| **ReAct + compiler** | 30000 | **143/156 (91.7%)** | **98.1%** | **0** | 3 | 520,082 | **14.97 h** |
| ReAct + compiler + RAG | 30000 | 138/156 (88.5%) | 96.8% | 1 | 4 | 486,163 | 13.82 h |

## VerilogEval-syntax (repair, 158 problems)

| configuration | budget | functional pass | fix rate | truncated | compile err | completion tok | compute | RAG calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| one-shot fix | 8192 | 122/158 (77.2%) | 81.6% | 28 | 1 | 505,350 | 14.10 h | 0 |
| ReAct + compiler | 8192 | 140/158 (88.6%) | 97.5% | 2 | 2 | 354,974 | 10.04 h | 0 |
| ReAct + compiler + RAG | 8192 | 144/158 (91.1%) | 98.1% | 2 | 1 | 312,431 | 9.19 h | 11 |
| one-shot fix | 30000 | 140/158 (88.6%) | 97.5% | 3 | 1 | 700,146 | 18.93 h | 0 |
| ReAct + compiler | 30000 | 143/158 (90.5%) | 98.1% | 2 | 1 | 397,236 | 11.15 h | 0 |
| **ReAct + compiler + RAG** | 30000 | **144/158 (91.1%)** | **98.7%** | **0** | 1 | 386,361 | 10.89 h | 21 |

## How much of the reported gain was budget

| effect | at 8192 | at 30000 | share that was budget |
| --- | --- | --- | --- |
| compiler tool, generation (syntax OK) | +9.6pp | **+5.8pp** | ~40% |
| compiler tool, repair (fix rate) | +15.8pp | **+0.6pp** | ~96% |
| RAG, repair (fix rate) | +0.6pp | +0.6pp | — (zero either way) |
| RAG, generation (syntax OK) | −0.6pp | −1.3pp | — (negative either way) |

## Reading

**The compiler tool works, and it is worth much less than the fixed-budget
numbers claim.**

* On **generation** the honest figure is +5.8pp syntax and +5.2pp pass@1. It
  also drives truncation to **zero**, which the 30k baseline does not manage —
  an external stopping signal beats simply having more room.
* On **repair** the gain nearly vanishes: +0.6pp. Given enough budget, one-shot
  reaches 97.5% unaided, so there is almost nothing left to add. This is the
  benchmark the paper's headline is measured on.
* **RAG** is flat on repair at both budgets and negative on generation, where it
  was never called at all (0 calls across 312 problems).

ReAct is also **cheaper at equal budget** — 14.97 h vs 21.03 h on generation,
11.15 h vs 18.93 h on repair — because chopping the work into tool-terminated
turns stops the model burning the whole budget on one long chain of thought.

## Two conclusions this ablation corrected

1. The original report credited the tool with the full 8192-budget gain. Most of
   the repair gain, and ~40% of the generation gain, was budget.
2. The first version of this ablation over-corrected and credited the budget
   with *all* of it, on the strength of an asymmetric comparison. At equal
   budget the tool still wins on both benchmarks.

## Still open

* **gemma was not re-run at 30000.** Every gemma figure in the main report
  carries the confound quantified here.
* **Single sample at temperature 0.4.** The 30k generation gap (143 vs 135, 8
  problems) is the largest clean effect measured and is probably real; the 30k
  repair gap (143 vs 140, 3 problems) is inside the noise band.
