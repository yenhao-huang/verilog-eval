module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // One-hot next-state logic.
    // If multiple state bits are set, the next-state result is the union
    // of the transitions from all currently active states.
    assign next_state = {
        // next_state[9] : S6 --0--> S9
        (!in & state[6]),

        // next_state[8] : S5 --0--> S8
        (!in & state[5]),

        // next_state[7] : S6 --1--> S7, S7 --1--> S7
        (in & (state[6] | state[7])),

        // next_state[6] : S5 --1--> S6
        (in & state[5]),

        // next_state[5] : S4 --1--> S5
        (in & state[4]),

        // next_state[4] : S3 --1--> S4
        (in & state[3]),

        // next_state[3] : S2 --1--> S3
        (in & state[2]),

        // next_state[2] : S1 --1--> S2
        (in & state[1]),

        // next_state[1] : S0 --1--> S1, S8 --1--> S1, S9 --1--> S1
        (in & (state[0] | state[8] | state[9])),

        // next_state[0] : S0/S1/S2/S3/S4/S7/S8/S9 --0--> S0
        (!in & (state[0] | state[1] | state[2] | state[3] |
                state[4] | state[7] | state[8] | state[9]))
    };

    // Output logic:
    // S8 and S9 assert out1.
    // S7 and S9 assert out2.
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule
