module TopModule (
    input  wire       in,
    input  wire [3:0] state,
    output wire [3:0] next_state,
    output wire       out
);

    // One-hot encoding:
    // state[0] = A, state[1] = B, state[2] = C, state[3] = D

    // Next-state logic derived by inspection
    assign next_state[0] = (~in) & (state[0] | state[2]); // A
    assign next_state[1] =  in   & (state[0] | state[1] | state[3]); // B
    assign next_state[2] = (~in) & (state[1] | state[3]); // C
    assign next_state[3] =  in   & state[2];              // D

    // Moore output: asserted only in state D
    assign out = state[3];

endmodule
