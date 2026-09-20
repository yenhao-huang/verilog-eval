# What the fix-rate gain is actually made of

The headline repair numbers look like a clean replication of RTLFixer:

| model | configuration | fix rate |
| --- | --- | --- |
| qwen3.8-next | one-shot fix | 81.6% |
| qwen3.8-next | ReAct + compiler | 97.5% |
| qwen3.8-next | ReAct + compiler + RAG | **98.1%** |

RTLFixer reports 98.5% for ReAct + RAG. The numbers nearly coincide. **The
mechanism does not.**

## Decomposition

"Fix rate" counts a problem as fixed when the final code compiles. A problem can
fail that test two ways: the model emits code that still does not compile, or
the model never emits code at all because it ran past the completion budget.
Separating them:

| cell | truncated | compile_error | produced code | of those, compiled | fix rate *given* output |
| --- | --- | --- | --- | --- | --- |
| qwen / one-shot | 28 | 1 | 130 | 129 | **99.2%** |
| qwen / ReAct + compiler | 2 | 2 | 156 | 154 | **98.7%** |
| qwen / ReAct + compiler + RAG | 2 | 1 | 156 | 155 | **99.4%** |
| gemma / one-shot | 34 | 1 | 124 | 123 | **99.2%** |
| gemma / ReAct + compiler | 17 | 3 | 141 | 138 | **97.9%** |
| gemma / ReAct + compiler + RAG | 23 | 3 | 135 | 132 | **97.8%** |

Two things are immediately visible:

1. **Compile errors barely move.** qwen: 1 → 2 → 1 out of 158. gemma: 1 → 3 → 3.
   Whatever the configuration, these models repair the seeded syntax error on
   their first attempt.
2. **Conditional on producing any output at all, every configuration sits at
   97.8–99.4%** — including one-shot, which has no compiler tool and no RAG.

The entire headline improvement is the truncation column: qwen 28 → 2,
gemma 34 → 17.

## What this means

We did **not** reproduce the paper's mechanism. RTLFixer's premise is that the
model cannot fix the error unaided and needs iterative compiler feedback plus
expert guidance to get there. For these two 2026-era models, the premise does
not hold: they fix the error unaided, at 99%, on the first try.

What the compiler tool actually buys is unrelated to syntax knowledge. It gives
the model an **external stopping signal**. Left alone, both models reason for
tens of thousands of tokens on hard problems and never emit an answer — one
probe needed 30,136 reasoning tokens and 51 minutes to terminate naturally
(`token_budget_probe.md`). Handed a tool that says "compiled, you're done", the
model stops and answers.

So the honest reading of these tables is:

> On VerilogEval-syntax, ReAct with a compiler tool raises qwen3.8-next's fix
> rate from 81.6% to 97.5%, but **not** by repairing more syntax errors — it
> repairs the same number. It works by cutting runaway reasoning, taking
> truncated attempts from 28 to 2.

## Why the paper could not have seen this

RTLFixer used GPT-3.5 and GPT-4 in 2023–24, at `max_tokens=2048`. Neither model
emitted reasoning tokens, so "the model thinks so long it never answers" was not
a failure mode that existed. It is specific to the reasoning-model era, and on
this benchmark it is now the *dominant* failure mode — larger than syntax errors
and functional mismatches combined.

## Does this invalidate the comparison?

No, but it changes what the comparison is evidence *for*. ReAct + compiler is
still clearly the better configuration on the repair task for both models, and
for qwen it is also cheaper (14.10 → 10.04 problem-hours). The claim that is not
supported is the causal one in the paper: that the gain comes from compiler
feedback teaching the model to fix syntax it could not otherwise fix.

A follow-up that would isolate the paper's mechanism: re-run one-shot with a
completion budget large enough that truncation reaches zero (~32k tokens), and
compare fix rates then. If the paper's mechanism is real here, ReAct should
still win; on the evidence above, it should not. That run costs roughly 50
minutes per hard problem and was not attempted.
