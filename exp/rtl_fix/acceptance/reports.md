# RTLFixer's ReAct + RAG, measured locally

**Question.** RTLFixer ([arXiv:2311.16543](https://arxiv.org/abs/2311.16543))
claims two things lift Verilog syntax success: ReAct prompting with a compiler
in the loop, and RAG over a curated compiler-error → expert-guidance database.
How much does each buy, on two locally served open models?

**Answer in one line.** The compiler tool is worth about **+5pp** on generation
and **+0.6pp** on repair once both arms get the same token budget — smaller than
a naive comparison suggests, but real. RAG is worth nothing on either.

---

## 1. Headline: the same comparison at two budgets

The main matrix ran every configuration at `max_tokens=8192`. That is not a fair
fight: ReAct's turn structure hands the model a fresh 8192 tokens on each of up
to ten iterations, while a single-call configuration gets one. At 8192, 17–22%
of single-call problems hit the cap and produced nothing, so "ReAct truncates
less" could mean the tool helped — or merely that ReAct was allowed to finish.

Re-running **all six** qwen3.8-next cells at `max_tokens=30000` settles it.

### VerilogEval-v2 (spec-to-rtl generation, 156 problems)

| model | configuration | budget | pass@1 | syntax OK | truncated | compile err | completion tok | compute |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| qwen3.8-next | baseline (no tools) | 8192 | 118/156 (75.6%) | 79.5% | 27 | 5 | 444k | 15.74 h |
| qwen3.8-next | ReAct + compiler | 8192 | 131/156 (84.0%) | 89.1% | 14 | 3 | 361k | 10.87 h |
| qwen3.8-next | ReAct + compiler + RAG | 8192 | 127/156 (81.4%) | 88.5% | 14 | 4 | 351k | 10.31 h |
| gemma-4-26B-A4B | baseline (no tools) | 8192 | 115/156 (73.7%) | 79.5% | 30 | 2 | 529k | 9.29 h |
| gemma-4-26B-A4B | ReAct + compiler | 8192 | 118/156 (75.6%) | 82.1% † | 23 | 5 | 693k | 11.72 h |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 8192 | 117/156 (75.0%) | 81.4% † | 24 | 5 | 714k | 11.87 h |
| qwen3.8-next | baseline (no tools) | **30000** | 135/156 (86.5%) | 92.3% | 5 | 7 | 780k | 21.03 h |
| qwen3.8-next | **ReAct + compiler** | **30000** | **143/156 (91.7%)** | **98.1%** | **0** | 3 | 520k | **14.97 h** |
| qwen3.8-next | ReAct + compiler + RAG | **30000** | 138/156 (88.5%) | 96.8% | 1 | 4 | 486k | 13.82 h |

### VerilogEval-syntax (repair, 158 problems)

| model | configuration | budget | functional pass | fix rate | truncated | compile err | completion tok | compute | RAG calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| qwen3.8-next | one-shot fix | 8192 | 122/158 (77.2%) | 81.6% | 28 | 1 | 505k | 14.10 h | 0 |
| qwen3.8-next | ReAct + compiler | 8192 | 140/158 (88.6%) | 97.5% | 2 | 2 | 355k | 10.04 h | 0 |
| qwen3.8-next | ReAct + compiler + RAG | 8192 | 144/158 (91.1%) | 98.1% | 2 | 1 | 312k | 9.19 h | 11 |
| gemma-4-26B-A4B | one-shot fix | 8192 | 112/158 (70.9%) | 77.8% | 34 | 1 | 685k | 11.25 h | 0 |
| gemma-4-26B-A4B | ReAct + compiler | 8192 | 126/158 (79.7%) | 87.3% † | 17 | 3 | 639k | 10.80 h | 0 |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 8192 | 118/158 (74.7%) | 83.5% † | 23 | 3 | 771k | 13.16 h | 26 |
| qwen3.8-next | one-shot fix | **30000** | 140/158 (88.6%) | 97.5% | 3 | 1 | 700k | 18.93 h | 0 |
| qwen3.8-next | ReAct + compiler | **30000** | 143/158 (90.5%) | 98.1% | 2 | 1 | 397k | 11.15 h | 0 |
| qwen3.8-next | **ReAct + compiler + RAG** | **30000** | **144/158 (91.1%)** | **98.7%** | **0** | 1 | 386k | 10.89 h | 21 |

**gemma has no 30000 row.** It was not re-run, so the budget share measured for
qwen below is *not* known to transfer to it — every gemma figure here still
mixes the tool's effect with the budget's.

**† marks cells inflated by a harness fallback** that only tool-using
configurations can use (`details/harness_fallback_bias.md`). Removing it takes
gemma's generation syntax to 75.6% / 73.1% — *below* its own baseline — and its
repair fix rate to 81.6% / 77.8%. qwen's cells are unaffected (0–2 problems).

### What the two budgets say

| | measured at 8192 | measured at 30000 | how much was budget |
| --- | --- | --- | --- |
| ReAct + compiler, generation (syntax) | +9.6pp | **+5.8pp** | ~3.8pp |
| ReAct + compiler, repair (fix rate) | +15.8pp | **+0.6pp** | ~15.2pp |

**The compiler tool works, and it is worth far less than the 8192-budget
numbers claim.** On generation the honest figure is +5.8pp syntax / +5.2pp
pass@1. On repair it collapses to +0.6pp: once one-shot is allowed to finish it
reaches 97.5% on its own, leaving almost nothing for the tool to add.

ReAct is also **cheaper at equal budget** — 14.97 h against 21.03 h on
generation, 11.15 h against 18.93 h on repair — because the turn structure stops
the model over-reasoning instead of letting it burn the whole budget.

Detail: [`details/budget_ablation.md`](details/budget_ablation.md).

---

## 2. The 8192-budget matrix — all 12 cells, both models

gemma was not re-run at 30000, so its cells below carry the same budget
confound quantified above. Read every Δ in this section as *at a fixed 8192
budget*.

### VerilogEval-v2 (spec-to-rtl generation, 156 problems)

| model | configuration | pass@1 | Δpp | syntax OK | syntax OK* | Δpp* | compute (problem-h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| qwen3.8-next | baseline (no tools) | 75.6% | — | 79.5% | 79.5% | — | 15.74 |
| qwen3.8-next | ReAct + compiler | **84.0%** | **+8.3** | 89.1% | 89.1% | **+9.6** | 10.87 |
| qwen3.8-next | ReAct + compiler + RAG | 81.4% | +5.8 | 88.5% | 88.5% | +9.0 | 10.31 |
| gemma-4-26B-A4B | baseline (no tools) | 73.7% | — | 79.5% | 79.5% | — | 9.29 |
| gemma-4-26B-A4B | ReAct + compiler | 75.6% | +1.9 | 82.1% | 75.6% | **−3.9** | 11.72 |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 75.0% | +1.3 | 81.4% | 73.1% | **−6.4** | 11.87 |

\* Same correction as above. **With the fallback removed, ReAct does not help
gemma generate Verilog — it hurts.**


### VerilogEval-syntax (repair, 158 problems) — the paper's own setting

| model | configuration | fix rate | fix rate* | Δpp* | functional pass | compute (problem-h) |
| --- | --- | --- | --- | --- | --- | --- |
| qwen3.8-next | one-shot fix | 81.6% | 81.6% | — | 122/158 (77.2%) | 14.10 |
| qwen3.8-next | ReAct + compiler | 97.5% | 96.2% | **+14.6** | 140/158 (88.6%) | 10.04 |
| qwen3.8-next | ReAct + compiler + RAG | 98.1% | 98.1% | +16.5 | 144/158 (91.1%) | 9.19 |
| gemma-4-26B-A4B | one-shot fix | 77.8% | 77.8% | — | 112/158 (70.9%) | 11.25 |
| gemma-4-26B-A4B | ReAct + compiler | 87.3% | 81.6% | **+3.8** | 126/158 (79.7%) | 10.80 |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 83.5% | 77.8% | **±0.0** | 118/158 (74.7%) | 13.16 |

\* A harness fallback grades the last tool-compiled snippet when the agent's
closing message has no code. Only ReAct configurations can use it, so it
flatters them. The starred columns remove it. It costs qwen almost nothing and
gemma a great deal — see
[`details/harness_fallback_bias.md`](details/harness_fallback_bias.md).

---

## 3. The three findings

### 3.1 Most of the 8192-budget gain is not syntax repair

qwen's 81.6% → 97.5% fix rate looks like a textbook replication — RTLFixer
reports 98.5% for ReAct + RAG, we measure 98.1%. **The numbers coincide; the
mechanism does not.** Splitting "did not compile" into its two causes:

| cell | truncated | compile_error | produced code | fix rate *given* output |
| --- | --- | --- | --- | --- |
| qwen / one-shot | 28 | 1 | 130 | **99.2%** |
| qwen / ReAct + compiler | 2 | 2 | 156 | **98.7%** |
| qwen / ReAct + compiler + RAG | 2 | 1 | 156 | **99.4%** |
| gemma / one-shot | 34 | 1 | 124 | **99.2%** |
| gemma / ReAct + compiler | 17 | 3 | 141 | **97.9%** |
| gemma / ReAct + compiler + RAG | 23 | 3 | 135 | **97.8%** |

Compile errors barely move (qwen 1 → 2 → 1 out of 158). Whenever these models
emit any code at all, it compiles ~99% of the time — **including one-shot, which
has no tools**. The entire headline gain is the truncation column: 28 → 2.

RTLFixer's premise is that the model *cannot* fix the error unaided. For these
two 2026-era models that premise is largely false: they fix it unaided, first
try, at 99%. Most of what the compiler tool provides is an **external stopping
signal**, and §1 shows a larger budget provides most of that without any tool —
the repair gain falls from +15.8pp to +0.6pp once both arms can finish.

A residue survives. On generation the tool is still worth +5.8pp syntax at equal
budget, and it drives truncation to **zero** where the 30k baseline still loses
5 problems to it. The stopping signal is better than simply having more room.
Detail: [`details/what_the_gain_is_made_of.md`](details/what_the_gain_is_made_of.md).

### 3.2 RAG contributes nothing measurable

| model | budget | ReAct + compiler | + RAG | Δ |
| --- | --- | --- | --- | --- |
| qwen3.8-next | 8192 | 97.5% | 98.1% | +0.6 |
| qwen3.8-next | 30000 | 98.1% | 98.7% | +0.6 |
| qwen3.8-next (generation) | 30000 | 98.1% | 96.8% | **−1.3** |
| gemma-4-26B-A4B | 8192 | 87.3% | 83.5% | **−3.8** |

The same ±0.6pp at both budgets on repair, and *negative* on generation. RAG
fired 21 times in the best repair cell and 0 times across all 312 generation
problems. Attribution shows none of this is a RAG effect:

* **qwen** — the RAG tool fired on 11 problems; compiler-only had already passed
  **all 11**. Every problem that changed verdict (6 gained, 2 lost) had
  `rag_calls == 0`.
* **gemma** — fired on 26 problems, 22 already passing. Only 3 of 20 changed
  problems had touched RAG, and the configuration finished 8 problems behind.

The retriever is not broken: offline it matches 128 of the 158 starting compiler
logs, and it returns guidance when called. There is simply no residue of
unfixable syntax errors for it to act on. On the generation benchmark it is
worse still — **`rag_calls` was 0 across all 312 problems for both models**,
because the models produced no compile errors inside the agent loop at all.
Detail: [`details/rag_attribution.md`](details/rag_attribution.md).

### 3.3 Truncation, not syntax, is the dominant failure mode

Outcome distribution, VerilogEval-v2 generation:

| model | configuration | pass | functional mismatch | compile error | truncated |
| --- | --- | --- | --- | --- | --- |
| qwen3.8-next | baseline | 118 | 6 | 5 | **27** |
| qwen3.8-next | ReAct + compiler | 131 | 8 | 3 | **14** |
| qwen3.8-next | ReAct + compiler + RAG | 127 | 11 | 4 | 14 |
| gemma-4-26B-A4B | baseline | 115 | 9 | 2 | **30** |
| gemma-4-26B-A4B | ReAct + compiler | 118 | 10 | 5 | 23 |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 117 | 10 | 5 | 24 |

Compile errors: 2–5 per 156. Truncations: 14–30. The failure mode RTLFixer was
built to solve has become the *rarest* one; the one it never saw is now the
largest. RTLFixer used GPT-3.5/GPT-4 at `max_tokens=2048`, neither of which
emitted reasoning tokens, so "thinks so long it never answers" did not exist as
a category. A probe on one truncated problem needed **30,136 reasoning tokens** to terminate
naturally — nearly four times the budget every cell was given.
Detail: [`details/token_budget_probe.md`](details/token_budget_probe.md).

---

## 4. Model comparison

ReAct helps the two models very differently, and the split is informative:

| | qwen3.8-next | gemma-4-26B-A4B |
| --- | --- | --- |
| ReAct Δ on generation (syntax OK, fallback removed) | **+9.6pp** | **−3.9pp** |
| ReAct Δ on repair (fix rate, fallback removed) | **+14.6pp** | **+3.8pp** |
| truncations cut by ReAct (generation) | 27 → 14 | 30 → 23 |
| truncations cut by ReAct (repair) | 28 → **2** | 34 → 17 |
| relied on the harness fallback | 0–2 problems | 9–13 problems |
| compute change from ReAct (generation) | 15.74 → **10.87** h | 9.29 → **11.72** h |

The two models split cleanly. qwen takes the stopping signal: truncation on the
repair task collapses from 28 to 2, it never needs the fallback because it
repeats the module in its closing message, and its compute cost *drops* 31%
despite ReAct issuing about twice as many LLM calls.

gemma does not. Truncation only halves, it ends turns with prose instead of code
often enough that the fallback was carrying 4–8 of its passes, and ReAct makes
it **more** expensive. Once the fallback is removed, ReAct is worth +3.8pp to
gemma on repair — inside this experiment's noise band — and **−3.9pp on
generation**.

This is consistent with finding 3.1. If ReAct's value here is "stop
over-reasoning and answer", then its value to a given model is proportional to
how readily that model takes an external cue to stop — not to how much Verilog
syntax it gets wrong. qwen takes the cue; gemma does not, and pays the tool
round-trips for nothing.

**So the paper's method does not generalise across these two models.** On
qwen3.8-next it is a large, cheap win. On gemma-4-26B-A4B it is neutral at best
and negative on generation.

---

## 5. Cost

| model | configuration | compute (problem-h) | total tokens | tokens/solved | LLM calls/problem |
| --- | --- | --- | --- | --- | --- |
| qwen3.8-next | baseline | 15.74 | 491,136 | 4,162 | 1.00 |
| qwen3.8-next | ReAct + compiler | 10.87 | 634,456 | 4,843 | 1.95 |
| qwen3.8-next | ReAct + compiler + RAG | 10.31 | 642,553 | 5,059 | 1.84 |
| gemma-4-26B-A4B | baseline | 9.29 | 569,391 | 4,951 | 1.00 |
| gemma-4-26B-A4B | ReAct + compiler | 11.72 | 889,352 | 7,537 | 1.89 |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 11.87 | 937,763 | 8,015 | 1.88 |

ReAct always costs more **tokens** (multi-turn resends the transcript), but for
qwen it costs less **time**, because the tokens it stops spending on runaway
reasoning outweigh the tokens it adds in tool round-trips.

> Time is reported as **problem-hours** — the sum of per-problem wall time.
> `summary.json`'s `wall_seconds_total` measures only from the last `--resume`
> and understates any interrupted cell, so it is not comparable across cells.

---

## 6. qwen3.8-next: ReAct spends fewer tokens

ReAct issues about twice as many LLM calls, yet its **completion** token count
is consistently lower. Matched on problems that passed in *both* configurations,
so truncated and failed attempts cannot distort the comparison:

| | baseline completion | ReAct completion | ratio | of which reasoning |
| --- | --- | --- | --- | --- |
| generation @8192 (114 problems) | 170,729 | 122,677 | 72% | **51%** |
| generation @30000 (132 problems) | 436,964 | 304,169 | 70% | **59%** |
| repair @30000 (135 problems) | 422,604 | 234,641 | 56% | **40%** |

The saving is almost entirely **reasoning** tokens, not emitted code — the
reasoning ratio falls further than the total in every row.

### Case studies

Three problems from `results_budget30k/`, chosen as the largest reasoning gaps
among problems both configurations solved:

| problem | baseline reasoning | ReAct reasoning | change | baseline output | ReAct output |
| --- | --- | --- | --- | --- | --- |
| `Prob144_conwaylife` | 22,488 tok | **2,436 tok** | −89% | 1,313 chars | 2,284 chars |
| `Prob068_countbcd` | 9,501 tok | **2,135 tok** | −78% | 1,210 chars | 1,313 chars |
| `Prob124_rule110` | 8,295 tok | **2,653 tok** | −68% | 1,071 chars | 1,491 chars |

**ReAct thinks less and writes more.** Its visible output is longer in all three
— the multi-turn transcript repeats the module — while its reasoning collapses
by 68–89%.

All three ReAct transcripts open identically:

```
[2] assistant   content = 0 chars   tool_calls = ['verilog_compiler']
[3] tool        "The code has no compile error. I should give this
                 implementation to the user."
[4] assistant   <the final module>
```

The first turn carries **no prose at all**. The model spends ~2,400 reasoning
tokens producing code, hands it straight to the compiler, and is told it
compiles on the first attempt. Only then does it write its answer.

### What this does and does not show

Established, from the recorded token counts: ReAct reaches the same answers on
the same problems using 40–59% of the baseline's reasoning tokens.

An interpretation, **not measured**: the likely mechanism is not that the
compiler supplies information the model lacked — it almost never reports an
error (2 of 156 problems on qwen). It is that a cheap retry changes how much
certainty the model demands before committing. One-shot has to be right first
time, so it deliberates for 22,488 tokens; with a compiler behind it, the model
commits after 2,436 and lets the tool decide.

That reading cannot be confirmed from these runs: `transcript.json` stores the
assistant `content` but not the `reasoning` field, so there is no way to check
whether the baseline's 22,488 tokens were self-verification or genuine
derivation. Confirming it means re-running with the reasoning text captured,
which was not done.

---

## 7. Experimental setup

| | |
| --- | --- |
| hardware | 1 × NVIDIA GB10 (128 GB unified), one model resident at a time |
| qwen3.8-next | `Inferact-Qwen3.8-Flash-Next-NVFP4` on vLLM 0.19, `--speculative-config {"method":"mtp","num_speculative_tokens":2}`, 24 sequence slots, `--gpu-memory-utilization 0.85` |
| gemma-4-26B-A4B | `unsloth/gemma-4-26B-A4B-it` Q4_K_XL GGUF on a CUDA llama.cpp built for sm_121, 8 slots, no speculative decoding |
| generation benchmark | VerilogEval-v2, `dataset_spec-to-rtl`, 156 problems |
| repair benchmark | VerilogEval-syntax (RTLFixer), 158 of 174 rows — the 16 that compile cleanly under this iverilog are skipped |
| compiler | Icarus Verilog, `-Wall -Winfloop -Wno-timescale -g2012` |
| temperature / top_p | 0.4 / 1.0 — RTLFixer §4.1 |
| max ReAct iterations | 10 — RTLFixer §4.1 |
| completion budget | 8192 (**deviation**, see below) |
| samples per problem | 1 (pass@1) |

**Configurations.** `baseline` / `fix_oneshot` get no tools. `react_compiler`
adds `verilog_compiler`. `react_compiler_rag` adds `error_lookup` over
`knowledge/iverilog_guidance.json`. The agent never sees the testbench: its
compiler tool compiles the candidate module alone, and grading is a separate
offline step.

**Prompts** are transcribed verbatim from the paper's Figure 2; the one runtime
adaptation (OpenAI tool calling instead of literal `Action:` parsing, matching
the reference implementation) is documented in `prompts/SOURCES.md`.

---

## 8. Caveats — read these before quoting any number

1. **A harness fallback flattered ReAct, and is corrected in the starred
   columns only.** `run_react` grades the last tool-compiled snippet when the
   closing message has no code; no tool-less configuration can do this. It was
   worth 0 passes to qwen and 3–8 passes per cell to gemma, and removing it
   flips gemma's generation result from +2.6pp to −3.9pp. Unstarred columns
   still contain the bias. A clean replication should drop the fallback and
   re-run the eight ReAct cells; that was not done here.
   [`details/harness_fallback_bias.md`](details/harness_fallback_bias.md)
2. **ReAct gets more compute than the baseline.** The baseline gets one call of
   ≤8192 tokens; ReAct gets up to ten. This is inherent to the method and
   matches the paper, but it means the accuracy tables must be read next to the
   cost table. ReAct is not winning for free.
3. **The completion budget deviates from the paper, and the budget is the
   headline variable.** RTLFixer used 2048 with GPT-3.5. At 2048, qwen returned
   empty content on ~10% of problems. The main matrix uses 8192, where 17–22%
   of single-call problems still truncate — which §1 shows is what most of the
   apparent ReAct advantage was made of. The 30000-token cells are the control;
   quote §1 rather than §2 when comparing configurations.
4. **Single sample, temperature 0.4.** Differences of a few problems are noise.
   Treat +0.6pp and +1.9pp as zero; the ≥8pp effects are the ones that carry.
5. **`reasoning_tokens` is unavailable for gemma.** llama.cpp does not report it,
   so the "of which reasoning" column is 0 for gemma — that means *not measured*,
   not *no reasoning*.
6. **The two serving stacks differ**, including speculative decoding. qwen ran
   on vLLM with NVFP4 weights, 24 sequence slots and **MTP speculative decoding
   at `num_speculative_tokens=2`** (measured draft acceptance 68–93%, mean
   acceptance length 2.4–2.9). gemma ran on llama.cpp with a Q4_K_XL GGUF, 8
   slots and **no speculative decoding**. Rejection sampling preserves the
   target distribution, so this does not affect accuracy — but every qwen
   throughput and wall-clock figure carries an MTP speedup that gemma's does
   not. Cross-model *accuracy* is comparable; cross-model *speed* is not.
7. **The repair benchmark is filtered by our own toolchain.** 16 of RTLFixer's
   174 rows compile cleanly under this iverilog (they carry Quartus-only errors)
   and are excluded, so our 158-row fix rates are not directly comparable to the
   paper's 212-row or 174-row numbers.

---

## 9. Settled, and what is still open

The open question — whether ReAct's gain survives once truncation is removed —
is answered by the six-cell ablation in §1. It survives, reduced:

* **Generation:** +5.8pp syntax at equal budget, down from +9.6pp at 8192.
  Roughly 40% of the apparent gain was budget.
* **Repair:** +0.6pp at equal budget, down from +15.8pp. Roughly **96%** of the
  apparent gain was budget.
* **RAG:** nothing at either budget, on either benchmark.

Still open:

* **gemma was not re-run at 30000.** All of its numbers carry the budget
  confound quantified here. Its ReAct results were already neutral-to-negative
  after the harness-fallback correction, so the true figures are likely worse
  again — but that is an inference, not a measurement.
* **Single sample at temperature 0.4.** The generation gap at 30k (143 vs 135,
  8 problems) is the largest clean effect measured and is probably real; the
  repair gap (143 vs 140, 3 problems) is inside the noise band.
* **Only qwen was re-run**, so nothing here says whether the budget confound
  behaves the same way on a weaker model — which is precisely the regime the
  paper targets.

## 10. Reproducing

Step-by-step: [`reproduce.md`](reproduce.md). Raw per-cell metrics, per-problem
rows and generated tables: [`details/`](details/).
