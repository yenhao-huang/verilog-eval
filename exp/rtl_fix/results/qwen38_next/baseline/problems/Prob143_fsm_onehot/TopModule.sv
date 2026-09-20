module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire not_in = ~in;

    // Next-state logic
    // Transitions to S0 on in = 0 from S0, S1, S2, S3, S4, S7, S8, S9
    assign next_state[0] = not_in & (
        state[0] | state[1] | state[2] | state[3] |
        state[4] | state[7] | state[8] | state[9]
    );

    // Transitions to S1 on in = 1 from S0, S8, S9
    assign next_state[1] = in & (state[0] | state[8] | state[9]);

    // Remaining transitions
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];
    assign next_state[7] = in & (state[6] | state[7]);
    assign next_state[8] = not_in & state[5];
    assign next_state[9] = not_in & state[6];

    // Moore output logic
    // out1 is 1 in S8 and S9
    assign out1 = state[8] | state[9];

    // out2 is 1 in S7 and S9
    assign out2 = state[7] | state[9];

endmodule
