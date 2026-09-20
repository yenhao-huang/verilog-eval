module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoding: A=state[0], B=state[1], C=state[2], D=state[3]

    // Next state A: (A, in=0) or (C, in=0)
    assign next_state[0] = ~in & (state[0] | state[2]);

    // Next state B: (A, in=1) or (B, in=1) or (D, in=1)
    assign next_state[1] =  in & (state[0] | state[1] | state[3]);

    // Next state C: (B, in=0) or (D, in=0)
    assign next_state[2] = ~in & (state[1] | state[3]);

    // Next state D: (C, in=1)
    assign next_state[3] =  in & state[2];

    // Moore output: asserted only in state D
    assign out = state[3];

endmodule
