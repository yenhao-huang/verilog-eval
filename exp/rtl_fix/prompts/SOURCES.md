# Prompt provenance

All files in this directory are transcribed from:

> Yun-Da Tsai, Mingjie Liu, Haoxing Ren.
> *RTLFixer: Automatically Fixing RTL Syntax Errors with Large Language Models.*
> DAC 2024. arXiv:2311.16543.
> Local copy: `../docs/assets/RTLFixer Automatically Fixing RTL Syntax Errors with Large.pdf`
> HTML used for transcription: https://ar5iv.labs.arxiv.org/html/2311.16543

| File | Paper location | Transcription |
| --- | --- | --- |
| `react_instruction.txt` | Figure 2(b), "ReAct Instruction (System Prompt)" | verbatim |
| `react_steps_example.txt` | Figure 2(c), "ReAct Steps with Thought-Action-Observation" | verbatim (typographic quotes normalised to ASCII) |
| `oneshot_template.txt` | Figure 2(a), "One-shot Prompt Template" | verbatim (figure arrows `⬇` dropped) |
| `system_generate.txt` | Section 3.1 / Figure 2(a) system prompt line | verbatim |
| `react_system_runtime.txt` | Figure 2(b) + runtime framing | adapted — see below |
| `react_system_runtime_norag.txt` | Figure 2(b) without action (3) + runtime framing | adapted — used by the `react_compiler` configuration, which has no RAG tool |

## Why `react_system_runtime.txt` is adapted

Figure 2(b) describes the agent's action space in prose, because RTLFixer's
reference implementation drives the loop with OpenAI *function calling*
(`AgentType.OPENAI_FUNCTIONS` in
[`NVlabs/RTLFixer`](https://github.com/NVlabs/RTLFixer),
`src/generators/agents/rtlfixer.py`), not with literal `Action:` text parsing.
We do the same: the three action types of Figure 2(b) map onto

| Figure 2(b) action | Runtime tool |
| --- | --- |
| `Compiler[code]` | `verilog_compiler(code_completion)` |
| `RAG[logs]` | `error_lookup(compile_error_message)` |
| `Finish[answer]` | the model's final assistant message |

`react_system_runtime.txt` keeps the Figure 2(b) wording intact and appends only
the task framing (VerilogEval `spec-to-rtl` generation instead of repairing one
supplied erroneous implementation) and the module-name contract required by the
VerilogEval testbenches (`TopModule`, not the paper's `top_module`).
