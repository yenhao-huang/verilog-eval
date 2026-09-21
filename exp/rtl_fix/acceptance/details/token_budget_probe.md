# Why the completion budget is 8192, and what truncation means

## The problem

RTLFixer used `max_tokens=2048` with GPT-3.5, which emits no reasoning tokens.
Both models tested here spend part of the same budget on reasoning, so the
paper's number is not transferable. Two budgets were tried:

| budget | effect on the qwen baseline |
| --- | --- |
| 2048 (paper's value) | 6 of the first 63 problems returned an empty `content` with `finish_reason: "length"` — pure truncation artefacts that would have been scored as the model failing to produce code |
| 8192 (used here) | 24 of 156 problems still truncate |

## The probe

To decide whether a larger budget would fix the remaining 24, one truncated
problem was re-run single-shot with `max_tokens=32768`:

```
problem:            Prob153_gshare
config:             baseline (one-shot, no tools)
max_tokens:         32768
finish_reason:      stop           # completed naturally
completion_tokens:  30751
  of which reasoning: 30136
final answer:       2369 characters
elapsed:            3085 s         # under load — see below
```

So the model genuinely needs **~30k reasoning tokens** on this problem when it
has no tool to anchor it. That token count is a property of the problem.

**The 3085 s is not.** The probe ran while the 12-worker sweep was using the
same GPU, so it got 30751 / 3085 = **10.0 tok/s**, not the ~31 tok/s a single
request gets on an idle server. On an idle server the same generation would take
about **16 minutes**, and in a batched run it is throughput, not latency, that
sets the cost.

## Decision

Keep the budget at 8192 for every cell and report `truncated` as its own
outcome rather than hiding it inside `no_code`. Truncation at a fixed budget is
a real, comparable property of a configuration, and it is measured identically
across all six cells.

## Caveat this creates, stated plainly

The baseline gets **one** call of at most 8192 tokens. A ReAct configuration
gets up to **ten**. ReAct therefore has strictly more compute available, which
is inherent to the method (RTLFixer likewise allows 10 Thought-Action-Observation
iterations) but means the accuracy tables should always be read next to the
token and wall-clock tables. A configuration that wins on pass rate while
spending 5x the tokens has not won for free.

This also means part of ReAct's advantage on this benchmark comes from a
mechanism the paper does not discuss: the compiler tool gives the model an
external stopping signal, so it stops over-reasoning and emits code. The report
separates that effect from the syntax-repair effect the paper is about.
