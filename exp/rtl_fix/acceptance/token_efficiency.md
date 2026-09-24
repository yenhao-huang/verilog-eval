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
Every token figure is read from the two `record.json` files named in each
case; every listing is the **complete, unedited** source as recorded.

### `Prob144_conwaylife`

```
results_budget30k/qwen38_next/baseline/problems/Prob144_conwaylife/
results_budget30k/qwen38_next/react_compiler/problems/Prob144_conwaylife/
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | x2 |
| `prompt_tokens` | 524 | 2,597 | x4.96 |
| `completion_tokens` | 23,005 | 3,747 | -84% |
| `reasoning_tokens` | 22,488 | 2,436 | -89% |
| visible output (`completion − reasoning`) | 517 | 1,311 | x2.54 |
| `total_tokens` | 23,529 | 6,344 | -73% |
| `wall_seconds` | 2,326.7 | 388.5 | -83% |
| `outcome` | pass | pass | |

#### baseline — the one and only message

`transcript.json[2]`, `role=assistant`. The 22,488 reasoning tokens that
produced it **were not recorded** — see *The missing reasoning text* below.

```verilog
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer r, c, idx;
    integer n;

    // Optional simulation initialization.
    initial begin
        q = 256'd0;
        next_q = 256'd0;
    end

    // Synchronous state update.
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    // Combinational next-state calculation.
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                idx = r * 16 + c;

                // Count the 8 toroidal neighbors.
                n = q[(((r + 15) % 16) * 16) + ((c + 15) % 16)] +
                    q[(((r + 15) % 16) * 16) + c] +
                    q[(((r + 15) % 16) * 16) + ((c + 1) % 16)] +
                    q[(r * 16) + ((c + 15) % 16)] +
                    q[(r * 16) + ((c + 1) % 16)] +
                    q[(((r + 1) % 16) * 16) + ((c + 15) % 16)] +
                    q[(((r + 1) % 16) * 16) + c] +
                    q[(((r + 1) % 16) * 16) + ((c + 1) % 16)];

                // Game of Life rules.
                next_q[idx] = (n == 3) || (q[idx] && (n == 2));
            end
        end
    end

endmodule
```

#### ReAct turn 1 — `transcript.json[2]`, `content=""`, `tool_calls=[verilog_compiler]`

The argument `code_completion`, verbatim:

```verilog
module TopModule (
    input        clk,
    input        load,
    input  [255:0] data,
    output [255:0] q
);

    reg [255:0] q;
    reg [255:0] next_q;
    integer r, c;
    integer count;

    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                count = count + q[((r + 15) % 16) * 16 + ((c + 15) % 16)];
                count = count + q[((r + 15) % 16) * 16 + c];
                count = count + q[((r + 15) % 16) * 16 + ((c + 1) % 16)];
                count = count + q[r * 16 + ((c + 15) % 16)];
                count = count + q[r * 16 + ((c + 1) % 16)];
                count = count + q[((r + 1) % 16) * 16 + ((c + 15) % 16)];
                count = count + q[((r + 1) % 16) * 16 + c];
                count = count + q[((r + 1) % 16) * 16 + ((c + 1) % 16)];

                if (count == 3)
                    next_q[r * 16 + c] = 1'b1;
                else if (count == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
```

#### ReAct turn 1 observation — `transcript.json[3]`

```
The code has no compile error. I should give this implementation to the user.
```

#### ReAct turn 2 — `transcript.json[4]`, the graded answer

```verilog
module TopModule (
    input        clk,
    input        load,
    input  [255:0] data,
    output [255:0] q
);

    reg [255:0] q;
    reg [255:0] next_q;
    integer r, c;
    integer count;

    // Combinational next-state computation (Conway's Game of Life on a 16x16 torus)
    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                count = count + q[((r + 15) % 16) * 16 + ((c + 15) % 16)]; // up-left
                count = count + q[((r + 15) % 16) * 16 + c];               // up
                count = count + q[((r + 15) % 16) * 16 + ((c + 1) % 16)];  // up-right
                count = count + q[r * 16 + ((c + 15) % 16)];               // left
                count = count + q[r * 16 + ((c + 1) % 16)];                // right
                count = count + q[((r + 1) % 16) * 16 + ((c + 15) % 16)];  // down-left
                count = count + q[((r + 1) % 16) * 16 + c];                // down
                count = count + q[((r + 1) % 16) * 16 + ((c + 1) % 16)];   // down-right

                if (count == 3)
                    next_q[r * 16 + c] = 1'b1;
                else if (count == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 1'b0;
            end
        end
    end

    // Sequential state update with synchronous active-high load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
```

### `Prob068_countbcd`

```
results_budget30k/qwen38_next/baseline/problems/Prob068_countbcd/
results_budget30k/qwen38_next/react_compiler/problems/Prob068_countbcd/
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | x2 |
| `prompt_tokens` | 240 | 1,955 | x8.15 |
| `completion_tokens` | 9,955 | 3,079 | -69% |
| `reasoning_tokens` | 9,501 | 2,135 | -78% |
| visible output (`completion − reasoning`) | 454 | 944 | x2.08 |
| `total_tokens` | 10,195 | 5,034 | -51% |
| `wall_seconds` | 992.7 | 314.7 | -68% |
| `outcome` | pass | pass | |

#### baseline — the one and only message

`transcript.json[2]`, `role=assistant`. The 9,501 reasoning tokens that
produced it **were not recorded** — see *The missing reasoning text* below.

```verilog
module TopModule (
    input  wire        clk,
    input  wire        reset,
    output wire [2:0]  ena,
    output wire [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // q[3:0]   = ones
    // q[7:4]   = tens
    // q[11:8]  = hundreds
    // q[15:12] = thousands
    assign q = {thousands, hundreds, tens, ones};

    // ena[0] enables tens digit
    // ena[1] enables hundreds digit
    // ena[2] enables thousands digit
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && ena[0];
    assign ena[2] = (hundreds == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;

            if (ena[0])
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;

            if (ena[1])
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;

            if (ena[2])
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule
```

#### ReAct turn 1 — `transcript.json[2]`, `content=""`, `tool_calls=[verilog_compiler]`

The argument `code_completion`, verbatim:

```verilog
module TopModule (
    input  wire        clk,
    input  wire        reset,
    output wire [2:0]  ena,
    output reg  [15:0] q
);

    assign ena[0] = (q[3:0] == 4'd9);
    assign ena[1] = (q[7:4] == 4'd9) && ena[0];
    assign ena[2] = (q[11:8] == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            if (q[3:0] == 4'd9)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= q[3:0] + 4'd1;

            if (ena[0]) begin
                if (q[7:4] == 4'd9)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= q[7:4] + 4'd1;
            end

            if (ena[1]) begin
                if (q[11:8] == 4'd9)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= q[11:8] + 4'd1;
            end

            if (ena[2]) begin
                if (q[15:12] == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= q[15:12] + 4'd1;
            end
        end
    end

endmodule
```

#### ReAct turn 1 observation — `transcript.json[3]`

```
The code has no compile error. I should give this implementation to the user.
```

#### ReAct turn 2 — `transcript.json[4]`, the graded answer

```verilog
module TopModule (
    input  wire        clk,
    input  wire        reset,
    output wire [2:0]  ena,
    output reg  [15:0] q
);

    // Count enables: ena[i] asserts when digit (i+1) should increment
    assign ena[0] = (q[3:0]   == 4'd9);
    assign ena[1] = (q[7:4]   == 4'd9) && ena[0];
    assign ena[2] = (q[11:8]  == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // ones digit always counts
            if (q[3:0] == 4'd9)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= q[3:0] + 4'd1;

            // tens digit
            if (ena[0]) begin
                if (q[7:4] == 4'd9)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= q[7:4] + 4'd1;
            end

            // hundreds digit
            if (ena[1]) begin
                if (q[11:8] == 4'd9)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= q[11:8] + 4'd1;
            end

            // thousands digit
            if (ena[2]) begin
                if (q[15:12] == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= q[15:12] + 4'd1;
            end
        end
    end

endmodule
```

### `Prob124_rule110`

```
results_budget30k/qwen38_next/baseline/problems/Prob124_rule110/
results_budget30k/qwen38_next/react_compiler/problems/Prob124_rule110/
```

| field | baseline | ReAct + compiler | change |
| --- | --- | --- | --- |
| `llm_calls` | 1 | 2 | x2 |
| `prompt_tokens` | 475 | 2,224 | x4.68 |
| `completion_tokens` | 8,679 | 3,483 | -60% |
| `reasoning_tokens` | 8,295 | 2,653 | -68% |
| visible output (`completion − reasoning`) | 384 | 830 | x2.16 |
| `total_tokens` | 9,154 | 5,707 | -38% |
| `wall_seconds` | 862.6 | 348.9 | -60% |
| `outcome` | pass | pass | |

#### baseline — the one and only message

`transcript.json[2]`, `role=assistant`. The 8,295 reasoning tokens that
produced it **were not recorded** — see *The missing reasoning text* below.

```verilog
module TopModule (
    input            clk,
    input            load,
    input  [511:0]   data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Pad q with zeros to implement boundaries:
    // q[-1] = 0 and q[512] = 0
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q, 1'b0};

    // Rule 110 next-state function
    function rule110;
        input l, c, r;
        begin
            case ({l, c, r})
                3'b110,
                3'b101,
                3'b011,
                3'b010,
                3'b001: rule110 = 1'b1;
                default: rule110 = 1'b0;
            endcase
        end
    endfunction

    // Compute next state for all 512 cells
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            assign next_q[i] = rule110(q_ext[i + 2], q_ext[i + 1], q_ext[i]);
        end
    endgenerate

    // Synchronous load and state update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
```

#### ReAct turn 1 — `transcript.json[2]`, `content=""`, `tool_calls=[verilog_compiler]`

The argument `code_completion`, verbatim:

```verilog
module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    localparam [7:0] RULE_110 = 8'b01101110;

    wire [511:0] next_q;
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            assign next_q[i] = RULE_110[{padded_q[i+2], padded_q[i+1], padded_q[i]}];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
```

#### ReAct turn 1 observation — `transcript.json[3]`

```
The code has no compile error. I should give this implementation to the user.
```

#### ReAct turn 2 — `transcript.json[4]`, the graded answer

```verilog
module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Rule 110: index = {left, center, right}
    // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0  => 8'h6E
    localparam [7:0] RULE_110 = 8'b01101110;

    wire [511:0] next_q;

    // Zero padding: padded_q[i+1] = q[i], padded_q[0] = q[-1] = 0, padded_q[513] = q[512] = 0
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            // left = q[i+1], center = q[i], right = q[i-1]
            assign next_q[i] = RULE_110[{padded_q[i+2], padded_q[i+1], padded_q[i]}];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
```

---

## The missing reasoning text

Every listing above is a message the model *emitted*. None of them is the
reasoning that produced it, and that reasoning is the subject of this file —
22,488 tokens on `Prob144_conwaylife` against the agent's 2,436.

**It does not exist on disk.** The harness recorded only the count. `agent.py`
appended the assistant turn as

```python
messages.append({"role": "assistant", "content": content})
```

and the API's separate `reasoning` field was dropped. `usage` carried
`reasoning_tokens` through to `record.json`, so the size of the deliberation
survives; its content does not. Nothing in `results*/` can recover it.

Fixed for future runs, in this branch: `ChatClient.complete` now surfaces the
field, both agent paths write it into the transcript as a `reasoning` key, and
the client strips that key before sending the transcript back to the endpoint —
the transcript doubles as the wire format and `reasoning` is not an API field.
Runs made before that change, which is all eighteen cells here, remain without
it.

**Recovering it for these three problems would mean re-running them, and that
was deliberately not done.** Sampling is at temperature 0.4, so a re-run
produces a *different* deliberation of a different length. Its text could not be
placed next to the 22,488 figure without implying a correspondence that would
not exist. The honest record is: the counts are measured, the text is gone.

This is why the interpretation at the end of this file stays an interpretation.

## A drift the harness does not control for

In all three cases the module in the final message differs from the module that
was handed to the compiler. Across the whole cell
(`results_budget30k/qwen38_next/react_compiler/`):

| | problems |
| --- | --- |
| called the compiler at least once | 150 / 156 |
| graded code **identical** to the last compiled snippet | 71 |
| graded code **differs** from the last compiled snippet | **79** |
| …of those, failed to compile at grading time | 2 (`Prob151_review2015_fsm`, `Prob156_review2015_fancytimer`) |
| never called the compiler | 6 |

On **53% of problems the compiler blessed one artefact and a different one was
graded.** In the three cases here the edits are cosmetic — the
`Prob124_rule110` diff adds three comment lines and collapses two `begin`/`end`
pairs, logic untouched — but nothing in the harness enforces that.

Two of the three compile errors remaining in this cell are exactly this failure
mode: the agent compiled something clean, then edited it while writing the final
answer and broke it. A stricter harness would grade the compiled artefact, or
re-compile the final message before accepting it. Neither was done here, so the
`syntax OK` figures for every ReAct cell are a property of the *final message*,
not of anything the compiler actually approved.

## Reading the three together

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

## What this establishes, and what it does not

**Established**, from the recorded token counts: ReAct reaches the same answers
on the same problems using 40–59% of the baseline's reasoning tokens, and 27–62%
of its total tokens on these three cases.

**Interpretation, not measured.** The likely mechanism is *not* that the
compiler supplies information the model lacked — it almost never reports an
error at all (2 of 156 problems on qwen generation; see
[`details/what_the_gain_is_made_of.md`](details/what_the_gain_is_made_of.md)). It is that a
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
