# Why ReAct spends fewer tokens than the no-tool baseline

ReAct issues about twice as many LLM calls, yet its completion token count is
consistently *lower*. This file documents the effect and three worked cases.

All numbers are qwen3.8-next at `max_tokens=30000` unless stated, read from the
recorded `record.json` of each problem. Paths are relative to `exp/rtl_fix/`.

## The aggregate effect

Matched on problems that passed in **both** configurations, so truncated and
failed attempts cannot distort the comparison:

| set | baseline completion | ReAct completion | ratio | reasoning ratio |
| --- | --- | --- | --- | --- |
| generation @8192, 114 problems | 170,729 | 122,677 | 72% | **51%** |
| generation @30000, 132 problems | 436,964 | 304,169 | 70% | **59%** |
| repair @30000, 135 problems | 422,604 | 234,641 | 56% | **40%** |

The saving is almost entirely **reasoning** tokens: the reasoning ratio falls
further than the total in every row.

---

## Case studies

The three largest reasoning gaps among problems both configurations solved.
Every field below is copied from the two `record.json` files named above each
table.

### Case 1 — `Prob144_conwaylife`

```
results_budget30k/qwen38_next/baseline/problems/Prob144_conwaylife/record.json
results_budget30k/qwen38_next/react_compiler/problems/Prob144_conwaylife/record.json
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | ×2 |
| `prompt_tokens` | 524 | 2,597 | ×4.96 |
| `completion_tokens` | 23,005 | 3,747 | **−84%** |
| ` └ reasoning_tokens` | 22,488 | 2,436 | **−89%** |
| ` └ visible output` | 517 | 1,311 | ×2.54 |
| `total_tokens` | 23,529 | 6,344 | **−73%** |
| `compile_calls` | 0 | 1 | |
| `wall_seconds` | 2,326.7 | 388.5 | **−83%** |
| `outcome` | pass | pass | |

Reasoning is **97.8%** of the baseline's completion (22,488 of 23,005) and
**65.0%** of ReAct's (2,436 of 3,747).

### Case 2 — `Prob068_countbcd`

```
results_budget30k/qwen38_next/baseline/problems/Prob068_countbcd/record.json
results_budget30k/qwen38_next/react_compiler/problems/Prob068_countbcd/record.json
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | ×2 |
| `prompt_tokens` | 240 | 1,955 | ×8.15 |
| `completion_tokens` | 9,955 | 3,079 | **−69%** |
| ` └ reasoning_tokens` | 9,501 | 2,135 | **−78%** |
| ` └ visible output` | 454 | 944 | ×2.08 |
| `total_tokens` | 10,195 | 5,034 | **−51%** |
| `compile_calls` | 0 | 1 | |
| `wall_seconds` | 992.7 | 314.7 | **−68%** |
| `outcome` | pass | pass | |

### Case 3 — `Prob124_rule110`

```
results_budget30k/qwen38_next/baseline/problems/Prob124_rule110/record.json
results_budget30k/qwen38_next/react_compiler/problems/Prob124_rule110/record.json
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | ×2 |
| `prompt_tokens` | 475 | 2,224 | ×4.68 |
| `completion_tokens` | 8,679 | 3,483 | **−60%** |
| ` └ reasoning_tokens` | 8,295 | 2,653 | **−68%** |
| ` └ visible output` | 384 | 830 | ×2.16 |
| `total_tokens` | 9,154 | 5,707 | **−38%** |
| `compile_calls` | 0 | 1 | |
| `wall_seconds` | 862.6 | 348.9 | **−60%** |
| `outcome` | pass | pass | |

### Reading the three together

| | case 1 | case 2 | case 3 |
| --- | --- | --- | --- |
| reasoning | −89% | −78% | −68% |
| visible output | ×2.54 | ×2.08 | ×2.16 |
| prompt tokens | ×4.96 | ×8.15 | ×4.68 |
| **total tokens** | **−73%** | **−51%** | **−38%** |
| wall time | −83% | −68% | −60% |

**ReAct thinks far less and writes more.** Its prompt cost multiplies — the
transcript is resent every turn — and it still comes out 38–73% cheaper in
total, because reasoning dominates the baseline's bill (78–98% of its
completion tokens).

The wall-time saving tracks the completion saving rather than the total,
because prompt tokens are prefilled in a batch while completion tokens are
decoded one at a time.

---

## The transcript shape, identical in all three

From `results_budget30k/qwen38_next/react_compiler/problems/<problem>/transcript.json`:

```
[0] system      the ReAct instruction               1,055 chars
[1] user        the problem specification           1,420 chars
[2] assistant   content = 0 chars   tool_calls = ['verilog_compiler']
[3] tool        "The code has no compile error. I should give this
                 implementation to the user."         77 chars
[4] assistant   the final module                    2,284 chars
```

The first turn carries **no prose at all**. The model spends ~2,400 reasoning
tokens producing code, hands it straight to the compiler, and is told it
compiles on the first attempt. Only then does it write its answer.

The baseline transcript for the same problem
(`results_budget30k/qwen38_next/baseline/problems/Prob144_conwaylife/transcript.json`)
is three messages — system, user, assistant — with the whole 22,488-token
deliberation happening inside that single call.

---

## What this establishes, and what it does not

**Established**, from the recorded token counts: ReAct reaches the same answers
on the same problems using 40–59% of the baseline's reasoning tokens, and 27–62%
of its total tokens on these three cases.

**Interpretation, not measured.** The likely mechanism is *not* that the
compiler supplies information the model lacked — it almost never reports an
error at all (2 of 156 problems on qwen generation; see
[`what_the_gain_is_made_of.md`](what_the_gain_is_made_of.md)). It is that a
cheap retry changes how much certainty the model demands before committing.
One-shot has to be right the first time, so it deliberates for 22,488 tokens;
with a compiler behind it, the model commits after 2,436 and lets the tool
decide.

That reading **cannot be confirmed from these runs.** `transcript.json` stores
the assistant `content` but not the `reasoning` field, so there is no way to
check whether the baseline's 22,488 tokens were self-verification or genuine
derivation of the Conway's-life update rule. Confirming it means re-running
these problems with the reasoning text captured, which was not done.

A second caveat: these three are the *largest* reasoning gaps among
commonly-solved problems, chosen deliberately. They illustrate the mechanism;
the aggregate table at the top is what supports the size of the effect.
