# Did RAG actually cause the RAG configuration's gain?

A configuration that wins by a few problems at temperature 0.4 has not
necessarily won because of the thing it adds. This check attributes the gain of
`fix_react_compiler_rag` over `fix_react_compiler` on the repair task
(qwen3.8-next, 158 problems).

## Headline numbers

| configuration | fix rate | functional pass |
| --- | --- | --- |
| ReAct + compiler | 97.5% | 140/158 (88.6%) |
| ReAct + compiler + RAG | 98.1% | 144/158 (91.1%) |

Net +4 problems, which looks like a RAG effect.

## Where the +4 actually came from

The RAG tool fired on **11 of 158** problems. On all 11, the compiler-only
configuration had **already passed** — so RAG cannot have rescued any of them.

Every problem that changed verdict between the two configurations had
`rag_calls == 0`:

| problem | direction | rag_calls | compiler-only outcome |
| --- | --- | --- | --- |
| `2013_q2bfsm#0` | gained | 0 | functional_mismatch |
| `always_nolatches#2` | gained | 0 | compile_error |
| `edgecapture#1` | gained | 0 | functional_mismatch |
| `lfsr5#0` | gained | 0 | truncated |
| `mt2015_eq2#0` | gained | 0 | compile_error |
| `rule110#2` | gained | 0 | functional_mismatch |
| `2012_q2b#1` | lost | 0 | pass |
| `always_case2#2` | lost | 0 | pass |

6 gained, 2 lost, net +4 — **none of them touched the RAG tool.**

## Conclusion

The +0.6pp fix rate and +2.5pp functional pass attributed to RAG in the headline
table are **sampling noise**, not a RAG effect. In this setup RAG contributed
nothing measurable.

## Why, and what it means for the paper's claim

The paper reports RAG lifting the ReAct fix rate from 79.9% to 98.5% (+18.6pp)
with GPT-3.5 and Quartus. That gain has no room to appear here for two reasons:

1. **The compiler-only configuration is already at 97.5%.** There are only 4
   unfixed problems left for RAG to win, so even a perfect retriever could add
   at most 2.5pp.
2. **The model rarely needs a second opinion.** It calls the compiler once per
   problem on average (1.06 calls) and usually fixes the error from the raw
   iverilog message alone, so the retriever is seldom consulted at all.

Which entries did fire, when they fired:

| entry | times hit |
| --- | --- |
| `unable-to-bind` | 6 |
| `invalid-module-instantiation` | 2 |
| `undeclared-identifier` | 1 |
| `not-a-valid-l-value` | 1 |

The retriever works — `knowledge/iverilog_guidance.json` matches 128 of the 158
starting compiler logs offline, and the tool returns guidance when called. It is
simply not the binding constraint for this model. The paper anticipates exactly
this: with GPT-4 it observed ReAct adding only ~1% over one-shot, and concluded
that its methods "narrow the gap between weaker LLMs and stronger ones".
