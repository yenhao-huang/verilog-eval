# Generated tables

Regenerate with `python3 analysis/aggregate.py`.

## Headline: accuracy

| model | configuration | passed | pass@1 | Δpp | syntax OK | Δpp |
| --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 112/158 | 70.9% | — | 77.8% | — |
| gemma4_26b_a4b | ReAct + compiler | 126/158 | 79.7% | +8.9 | 87.3% | +9.5 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 118/158 | 74.7% | +3.8 | 83.5% | +5.7 |
| qwen38_next | one-shot fix (compiler feedback) | 122/158 | 77.2% | — | 81.6% | — |
| qwen38_next | ReAct + compiler | 140/158 | 88.6% | +11.4 | 97.5% | +15.8 |
| qwen38_next | ReAct + compiler + RAG | 144/158 | 91.1% | +13.9 | 98.1% | +16.5 |

## Cost: time and tokens

| model | configuration | compute (problem-hours) | s/problem | LLM calls/problem | prompt tok | completion tok | of which reasoning | total tok | tok/problem | tok/solved |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 11.25 | 256.3 | 1.00 | 76,995 | 684,962 | 0 | 761,957 | 4,823 | 6,803 |
| gemma4_26b_a4b | ReAct + compiler | 10.80 | 246.1 | 2.07 | 286,680 | 639,367 | 0 | 926,047 | 5,861 | 7,350 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 13.16 | 299.8 | 2.38 | 365,154 | 770,523 | 0 | 1,135,677 | 7,188 | 9,624 |
| qwen38_next | one-shot fix (compiler feedback) | 14.10 | 321.2 | 1.00 | 79,055 | 505,350 | 488,381 | 584,405 | 3,699 | 4,790 |
| qwen38_next | ReAct + compiler | 10.04 | 228.7 | 2.05 | 346,897 | 354,974 | 268,022 | 701,871 | 4,442 | 5,013 |
| qwen38_next | ReAct + compiler + RAG | 9.19 | 209.5 | 2.09 | 402,871 | 312,431 | 220,024 | 715,302 | 4,527 | 4,967 |

## Tool usage

| model | configuration | iters/problem | problems using compiler | compile calls/problem | problems using RAG | RAG calls/problem | unfinished |
| --- | --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 1.00 | 0/158 | 0.00 | 0/158 | 0.00 | 0 |
| gemma4_26b_a4b | ReAct + compiler | 2.08 | 141/158 | 1.08 | 0/158 | 0.00 | 30 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 2.38 | 135/158 | 1.22 | 26/158 | 0.16 | 34 |
| qwen38_next | one-shot fix (compiler feedback) | 1.00 | 0/158 | 0.00 | 0/158 | 0.00 | 0 |
| qwen38_next | ReAct + compiler | 2.05 | 155/158 | 1.06 | 0/158 | 0.00 | 4 |
| qwen38_next | ReAct + compiler + RAG | 2.09 | 155/158 | 1.06 | 11/158 | 0.07 | 2 |

## Outcome distribution

| model | configuration | pass | functional_mismatch | compile_error | truncated |
| --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 112 | 11 | 1 | 34 |
| gemma4_26b_a4b | ReAct + compiler | 126 | 12 | 3 | 17 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 118 | 14 | 3 | 23 |
| qwen38_next | one-shot fix (compiler feedback) | 122 | 7 | 1 | 28 |
| qwen38_next | ReAct + compiler | 140 | 14 | 2 | 2 |
| qwen38_next | ReAct + compiler + RAG | 144 | 11 | 1 | 2 |

## Compile-error kinds

| model | configuration | bad_constant | other_elaboration_error | port_mismatch | syntax_error | total |
| --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 0 | 1 | 0 | 0 | 1 |
| gemma4_26b_a4b | ReAct + compiler | 0 | 0 | 0 | 3 | 3 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 1 | 0 | 0 | 2 | 3 |
| qwen38_next | one-shot fix (compiler feedback) | 0 | 0 | 1 | 0 | 1 |
| qwen38_next | ReAct + compiler | 0 | 0 | 0 | 2 | 2 |
| qwen38_next | ReAct + compiler + RAG | 0 | 0 | 0 | 1 | 1 |

## Pass rate by problem topic

| model | configuration | arithmetic | combinational | fsm | kmap_logic | other | sequential |
| --- | --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | one-shot fix (compiler feedback) | 11/13 | 76/98 | 9/19 | 1/4 | 2/2 | 13/22 |
| gemma4_26b_a4b | ReAct + compiler | 11/13 | 85/98 | 14/19 | 0/4 | 2/2 | 14/22 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 11/13 | 81/98 | 9/19 | 1/4 | 2/2 | 14/22 |
| qwen38_next | one-shot fix (compiler feedback) | 12/13 | 79/98 | 13/19 | 2/4 | 2/2 | 14/22 |
| qwen38_next | ReAct + compiler | 12/13 | 91/98 | 18/19 | 2/4 | 2/2 | 15/22 |
| qwen38_next | ReAct + compiler + RAG | 13/13 | 91/98 | 18/19 | 2/4 | 2/2 | 18/22 |

## Problems flipped relative to baseline

| model | configuration | newly passing | newly failing | net |
| --- | --- | --- | --- | --- |
| gemma4_26b_a4b | ReAct + compiler | 20 | 6 | +14 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 12 | 6 | +6 |
| qwen38_next | ReAct + compiler | 21 | 3 | +18 |
| qwen38_next | ReAct + compiler + RAG | 24 | 2 | +22 |
