# Did RAG actually cause the RAG configuration's gain?

A configuration that wins by a few problems at temperature 0.4 has not
necessarily won because of the thing it adds. This check attributes the
difference between `fix_react_compiler_rag` and `fix_react_compiler` on
VerilogEval-syntax (158 problems), for both models.

## Headline numbers

| model | ReAct + compiler | ReAct + compiler + RAG | Δ fix rate |
| --- | --- | --- | --- |
| qwen3.8-next | 97.5% | 98.1% | **+0.6** |
| gemma-4-26B-A4B | 87.3% | 83.5% | **-3.8** |

RAG helps one model slightly and hurts the other. Neither is a RAG effect.

## Attribution

| | qwen3.8-next | gemma-4-26B-A4B |
| --- | --- | --- |
| problems where the RAG tool fired | 11 | 26 |
| of those, compiler-only had **already passed** | 11 (all) | 22 of 26 |
| problems gained vs compiler-only | 6 | 6 |
| of those gained, RAG had fired | **0** | 2 |
| problems lost vs compiler-only | 2 | 14 |
| of those lost, RAG had fired | **0** | 1 |

For qwen, **every single problem that changed verdict had `rag_calls == 0`**.
The +0.6pp cannot be a RAG effect; it is resampling noise.

For gemma, 3 of the 20 changed problems had touched RAG — and the configuration
came out 8 problems *behind*. Its losses are truncations (17 → 23), caused by
the extra tool definition and tool round-trips lengthening the context, not by
the guidance being wrong.

## Which entries fired

| entry | qwen | gemma |
| --- | --- | --- |
| `unable-to-bind` | 6 | 11 |
| `not-a-valid-l-value` | 1 | 8 |
| `invalid-module-instantiation` | 2 | 0 |
| `undeclared-identifier` | 1 | 1 |

The retriever is working. Offline it matches 128 of the 158 starting compiler
logs, and when the agent calls it, it returns guidance.

## Conclusion

**RAG contributed nothing measurable on either model.** The paper's +18.6pp is
not reproduced, and the reason is visible in
[`what_the_gain_is_made_of.md`](what_the_gain_is_made_of.md): these models
already repair the seeded syntax error on the first attempt at ~99%, in every
configuration, including one with no tools at all. There is no residue of
unfixable syntax errors for expert guidance to act on.

The paper anticipates this. With GPT-4 it observed ReAct adding only ~1% over
one-shot and concluded that its methods "narrow the gap between weaker LLMs and
stronger ones". Both models tested here are on the strong side of that gap.
