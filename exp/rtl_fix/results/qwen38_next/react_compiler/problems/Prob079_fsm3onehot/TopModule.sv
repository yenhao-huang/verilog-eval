module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoding:
    // A = state[0], B = state[1], C = state[2], D = state[3]

    // Next-state logic derived by inspection from the transition table:
    //  A: reached from A (in=0) and C (in=0)
    assign next_state[0] = (~in) & (state[0] | state[2]);
    //  B: reached from A (in=1), B (in=1), D (in=1)
    assign next_state[1] =   in  & (state[0] | state[1] | state[3]);
    //  C: reached from B (in=0) and D (in=0)
    assign next_state[2] = (~in) & (state[1] | state[3]);
    //  D: reached from C (in=1)
    assign next_state[3] =   in  & state[2];

    // Moore output: asserted only in state D
    assign out = state[3];

endmodule
