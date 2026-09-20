# Generated tables

Regenerate with `python3 analysis/aggregate.py`.

## Headline: accuracy

| model | configuration | passed | pass@1 | Δpp | syntax OK | Δpp |
| --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 115/156 | 73.7% | — | 79.5% | — |
| gemma4_26b_a4b | ReAct + compiler | 118/156 | 75.6% | +1.9 | 82.1% | +2.6 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 117/156 | 75.0% | +1.3 | 81.4% | +1.9 |
| qwen38_next | baseline (no tools) | 118/156 | 75.6% | — | 79.5% | — |
| qwen38_next | ReAct + compiler | 131/156 | 84.0% | +8.3 | 89.1% | +9.6 |
| qwen38_next | ReAct + compiler + RAG | 127/156 | 81.4% | +5.8 | 88.5% | +9.0 |

## Cost: time and tokens

| model | configuration | compute (problem-hours) | s/problem | LLM calls/problem | prompt tok | completion tok | of which reasoning | total tok | tok/problem | tok/solved |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 9.29 | 214.5 | 1.00 | 40,410 | 528,981 | 0 | 569,391 | 3,650 | 4,951 |
| gemma4_26b_a4b | ReAct + compiler | 11.72 | 270.5 | 1.89 | 196,378 | 692,974 | 0 | 889,352 | 5,701 | 7,537 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 11.87 | 274.0 | 1.88 | 223,560 | 714,203 | 0 | 937,763 | 6,011 | 8,015 |
| qwen38_next | baseline (no tools) | 15.74 | 363.3 | 1.00 | 47,266 | 443,870 | 424,050 | 491,136 | 3,148 | 4,162 |
| qwen38_next | ReAct + compiler | 10.87 | 250.9 | 1.95 | 273,403 | 361,053 | 298,444 | 634,456 | 4,067 | 4,843 |
| qwen38_next | ReAct + compiler + RAG | 10.31 | 237.8 | 1.84 | 291,887 | 350,666 | 293,402 | 642,553 | 4,119 | 5,059 |

## Tool usage

| model | configuration | iters/problem | problems using compiler | compile calls/problem | problems using RAG | RAG calls/problem | unfinished |
| --- | --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 1.00 | 0/156 | 0.00 | 0/156 | 0.00 | 0 |
| gemma4_26b_a4b | ReAct + compiler | 1.90 | 132/156 | 0.90 | 0/156 | 0.00 | 43 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 1.88 | 132/156 | 0.88 | 0/156 | 0.00 | 40 |
| qwen38_next | baseline (no tools) | 1.00 | 0/156 | 0.00 | 0/156 | 0.00 | 0 |
| qwen38_next | ReAct + compiler | 1.95 | 137/156 | 0.91 | 0/156 | 0.00 | 14 |
| qwen38_next | ReAct + compiler + RAG | 1.84 | 123/156 | 0.84 | 0/156 | 0.00 | 14 |

## Outcome distribution

| model | configuration | pass | functional_mismatch | compile_error | truncated |
| --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 115 | 9 | 2 | 30 |
| gemma4_26b_a4b | ReAct + compiler | 118 | 10 | 5 | 23 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 117 | 10 | 5 | 24 |
| qwen38_next | baseline (no tools) | 118 | 6 | 5 | 27 |
| qwen38_next | ReAct + compiler | 131 | 8 | 3 | 14 |
| qwen38_next | ReAct + compiler + RAG | 127 | 11 | 4 | 14 |

## Compile-error kinds

| model | configuration | invalid_lvalue | other_elaboration_error | port_mismatch | syntax_error | total |
| --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 0 | 1 | 1 | 0 | 2 |
| gemma4_26b_a4b | ReAct + compiler | 0 | 1 | 0 | 4 | 5 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 0 | 2 | 0 | 3 | 5 |
| qwen38_next | baseline (no tools) | 2 | 1 | 2 | 0 | 5 |
| qwen38_next | ReAct + compiler | 0 | 2 | 1 | 0 | 3 |
| qwen38_next | ReAct + compiler + RAG | 1 | 2 | 1 | 0 | 4 |

## Pass rate by problem topic

| model | configuration | arithmetic | combinational | fsm | kmap_logic | sequential |
| --- | --- | --- | --- | --- | --- | --- |
| gemma4_26b_a4b | baseline (no tools) | 13/15 | 48/52 | 20/37 | 3/7 | 31/45 |
| gemma4_26b_a4b | ReAct + compiler | 13/15 | 48/52 | 22/37 | 4/7 | 31/45 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 13/15 | 48/52 | 22/37 | 3/7 | 31/45 |
| qwen38_next | baseline (no tools) | 14/15 | 46/52 | 22/37 | 4/7 | 32/45 |
| qwen38_next | ReAct + compiler | 14/15 | 49/52 | 27/37 | 5/7 | 36/45 |
| qwen38_next | ReAct + compiler + RAG | 14/15 | 50/52 | 25/37 | 5/7 | 33/45 |

## Problems flipped relative to baseline

| model | configuration | newly passing | newly failing | net |
| --- | --- | --- | --- | --- |
| gemma4_26b_a4b | ReAct + compiler | 9 | 6 | +3 |
| gemma4_26b_a4b | ReAct + compiler + RAG | 7 | 5 | +2 |
| qwen38_next | ReAct + compiler | 17 | 4 | +13 |
| qwen38_next | ReAct + compiler + RAG | 16 | 7 | +9 |
