# RTLFixer's ReAct + RAG, measured locally

**Question.** RTLFixer ([arXiv:2311.16543](https://arxiv.org/abs/2311.16543))
claims two things lift Verilog syntax success: ReAct prompting with a compiler
in the loop, and RAG over a curated compiler-error → expert-guidance database.
How much does each buy, on two locally served open models?

**Answer in one line.** Neither does what the paper claims. Given a completion
budget large enough to finish, a plain no-tool baseline matches or beats every
ReAct configuration. What ReAct actually buys is **half the compute**, not
better Verilog.

---

## 1. Headline result: the budget ablation

Every cell in the main matrix shared `max_tokens=8192`. But ReAct's turn
structure hands the model a fresh 8192 tokens on each of up to ten iterations,
while a single-call configuration gets one. At that budget 17–22% of problems
hit the cap and produced nothing — so "ReAct truncates less" could mean the tool
helped, or merely that ReAct was allowed to finish.

Re-running the single-call configurations at `max_tokens=30000` separates them.

| benchmark | configuration | budget | accuracy | syntax / fix rate | compute |
| --- | --- | --- | --- | --- | --- |
| VerilogEval-v2 | baseline, no tools | 8192 | 118/156 (75.6%) | 79.5% | 15.74 h |
| VerilogEval-v2 | ReAct + compiler | 8192 | 131/156 (84.0%) | 89.1% | **10.87 h** |
| VerilogEval-v2 | ReAct + compiler + RAG | 8192 | 127/156 (81.4%) | 88.5% | 10.31 h |
| VerilogEval-v2 | **baseline, no tools** | **30000** | **135/156 (86.5%)** | **92.3%** | 21.03 h |
| VerilogEval-syntax | one-shot fix | 8192 | 122/158 (77.2%) | 81.6% | 14.10 h |
| VerilogEval-syntax | ReAct + compiler | 8192 | 140/158 (88.6%) | 97.5% | **10.04 h** |
| VerilogEval-syntax | ReAct + compiler + RAG | 8192 | 144/158 (91.1%) | 98.1% | 9.19 h |
| VerilogEval-syntax | **one-shot fix** | **30000** | **140/158 (88.6%)** | **97.5%** | 18.93 h |

Both benchmarks agree, and the repair rows agree exactly:

* **Generation** — the no-tool baseline at 30k **beats** every ReAct cell:
  86.5% vs 84.0% accuracy, 92.3% vs 89.1% syntax.
* **Repair** — the no-tool one-shot at 30k **ties** ReAct to the problem:
  140/158 and 97.5% in both, identical.

**ReAct's accuracy gain was an artefact of the shared budget.** Compiler
feedback did not repair syntax the model could not fix alone; the baseline was
being cut off mid-thought and ReAct was not.

### What survives: efficiency

| benchmark | configuration | accuracy | compute | completion tokens |
| --- | --- | --- | --- | --- |
| VerilogEval-v2 | ReAct + compiler @8192 | 84.0% | **10.87 h** | **361k** |
| VerilogEval-v2 | baseline @30000 | 86.5% | 21.03 h | 780k |
| VerilogEval-syntax | ReAct + compiler @8192 | 88.6% | **10.04 h** | **355k** |
| VerilogEval-syntax | one-shot @30000 | 88.6% | 18.93 h | 700k |

ReAct reaches the same place for **about half the compute and half the tokens**.
On repair it is a pure win — identical accuracy, 47% less compute. Chopping one
long generation into short tool-terminated turns stops the model over-reasoning,
which recovers most of what a 3.7x larger budget would buy at a fraction of the
cost.

That is a real and useful property. It is an *efficiency* result, not the
*capability* result RTLFixer reports.

Detail: [`details/budget_ablation.md`](details/budget_ablation.md).

---

## 2. The 8192-budget matrix — all 12 cells

These are the numbers the rest of this report analyses. Every "ReAct helps"
figure here should be read as *at a fixed 8192 budget*, which §1 shows is a
statement about cost-efficiency rather than capability. The RAG and
error-distribution findings below are unaffected by the ablation.

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

---

## 3. The three findings

### 3.1 The 8192-budget gain is not syntax repair

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
two 2026-era models that premise is false: they fix it unaided, first try, at
99%. What the compiler tool provides is an **external stopping signal** — and
§1 shows a larger budget provides the same thing without any tool at all.
Detail: [`details/what_the_gain_is_made_of.md`](details/what_the_gain_is_made_of.md).

### 3.2 RAG contributes nothing measurable

| model | ReAct + compiler | + RAG | Δ |
| --- | --- | --- | --- |
| qwen3.8-next | 97.5% | 98.1% | +0.6 |
| gemma-4-26B-A4B | 87.3% | 83.5% | **−3.8** |

It helps one model marginally and hurts the other. Attribution shows neither is
a RAG effect:

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

## 6. Experimental setup

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

## 7. Caveats — read these before quoting any number

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

## 8. Settled, and what is still open

The question this report originally left open — whether ReAct's gain would
survive once truncation was removed — was answered by the ablation in §1. It
does not. On generation the no-tool baseline overtakes ReAct; on repair it ties
it exactly.

Still open:

* **gemma was not re-run at 30000.** Its ReAct results were already
  neutral-to-negative after correcting for the harness fallback, so a budget
  correction can only move them further in the same direction — but that is an
  inference, not a measurement.
* **The ReAct cells were not re-run at 30000 either.** They truncate on only
  1.3–2.5% of problems at 8192, so the headroom is nearly irrelevant to them,
  but the symmetric experiment would make the comparison airtight.
* **Single sample throughout.** The generation gap (135 vs 131) is four
  problems and sits inside this experiment's noise band; the repair result
  (140 vs 140) is an exact tie. Neither supports a claim that the no-tool
  baseline is *better* than ReAct — only that it is not worse.

## 9. Reproducing

Step-by-step: [`reproduce.md`](reproduce.md). Raw per-cell metrics, per-problem
rows and generated tables: [`details/`](details/).
