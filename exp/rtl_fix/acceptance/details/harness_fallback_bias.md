# A harness fallback that flatters ReAct, and how much

## The mechanism

`agent.run_react` has a fallback: if the agent's closing message contains no
code, but it had earlier compiled a candidate through the `verilog_compiler`
tool, that last compiled snippet is graded instead.

```python
if not code.strip() and toolkit.last_code.strip():
    code = toolkit.last_code
    code_from_tool = True
```

The intent was benign — an agent that says "done, it compiles" without repeating
the module should not be scored as producing nothing. But it is a rescue path
that **only the ReAct configurations have**. The one-shot and baseline
configurations have no tool, so they have no `last_code` to fall back on. Any
gain it produces is the harness's, not the method's.

Each affected problem is flagged with `code_from_tool: 1` in its record, so the
bias is measurable exactly.

## How often it fired, and what it was worth

| cell | passes | problems using the fallback | passes owed to it |
| --- | --- | --- | --- |
| qwen / react_compiler | 131 | 0 | **0** |
| qwen / react_compiler_rag | 127 | 0 | **0** |
| qwen / fix_react_compiler | 140 | 2 | **0** |
| qwen / fix_react_compiler_rag | 144 | 0 | **0** |
| gemma / react_compiler | 118 | 10 | **4** |
| gemma / react_compiler_rag | 117 | 13 | **8** |
| gemma / fix_react_compiler | 126 | 9 | **6** |
| gemma / fix_react_compiler_rag | 118 | 9 | **3** |

qwen almost never needs it: it repeats the module in its closing message. gemma
frequently ends with prose after a successful compile, so the fallback carries
real weight for it.

## Corrected numbers

Recomputed with every `code_from_tool` problem scored as producing no code —
the strictest reading, matching what the baseline would get.

### VerilogEval-syntax (repair), fix rate

| model | configuration | as reported | fallback removed | Δ vs its own one-shot |
| --- | --- | --- | --- | --- |
| qwen3.8-next | one-shot fix | 81.6% | 81.6% | — |
| qwen3.8-next | ReAct + compiler | 97.5% | 96.2% | **+14.6** |
| qwen3.8-next | ReAct + compiler + RAG | 98.1% | 98.1% | +16.5 |
| gemma-4-26B-A4B | one-shot fix | 77.8% | 77.8% | — |
| gemma-4-26B-A4B | ReAct + compiler | 87.3% | 81.6% | **+3.8** |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 83.5% | 77.8% | **±0.0** |

### VerilogEval-v2 (generation), syntax OK

| model | configuration | as reported | fallback removed | Δ vs its own baseline |
| --- | --- | --- | --- | --- |
| qwen3.8-next | baseline | 79.5% | 79.5% | — |
| qwen3.8-next | ReAct + compiler | 89.1% | 89.1% | **+9.6** |
| qwen3.8-next | ReAct + compiler + RAG | 88.5% | 88.5% | +9.0 |
| gemma-4-26B-A4B | baseline | 79.5% | 79.5% | — |
| gemma-4-26B-A4B | ReAct + compiler | 82.1% | 75.6% | **−3.9** |
| gemma-4-26B-A4B | ReAct + compiler + RAG | 81.4% | 73.1% | **−6.4** |

## What changes

**qwen's results stand.** The fallback contributed zero passes in three of its
four ReAct cells and one problem's worth of fix rate in the fourth. ReAct's
+14.6pp on repair and +9.6pp on generation are the method's.

**gemma's results change materially, and one conclusion flips.**

* On repair, ReAct's gain shrinks from +9.5pp to +3.8pp — still positive, but
  now within the range this experiment calls noise.
* On generation, ReAct goes from a small apparent gain (+2.6pp) to a **loss**
  (−3.9pp). With the fallback removed, ReAct does not help gemma generate
  Verilog; it hurts.
* The RAG configuration on repair goes to exactly zero improvement.

The strict reading is arguably too strict: a model that compiled correct code
and then failed to repeat it has demonstrated the capability, and a production
harness would sensibly keep the fallback. But the comparison against a
tool-less baseline is only honest under the strict reading, so that is the one
the conclusions use for gemma.

## Fix for future runs

Either give every configuration an equivalent rescue path, or drop the fallback
and require the final message to carry the code. The second is cleaner and is
what a replication should do. This was not re-run here — it would mean repeating
all eight ReAct cells — so the corrected columns above stand in for it, computed
from the recorded `code_from_tool` flags.
