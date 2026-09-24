module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire [9:0] next_if_0;
    wire [9:0] next_if_1;

    wire to_s0_on_0 = state[0] | state[1] | state[2] | state[3] | state[4] |
                      state[7] | state[8] | state[9];

    // in == 0: S0,S1,S2,S3,S4,S7,S8,S9 -> S0 ; S5 -> S8 ; S6 -> S9
    assign next_if_0 = {state[6], state[5], 7'b0, to_s0_on_0};

    // in == 1: S0,S8,S9 -> S1 ; S1->S2 ; S2->S3 ; S3->S4 ; S4->S5 ;
    //          S5->S6 ; S6,S7 -> S7
    assign next_if_1 = {1'b0,
                        1'b0,
                        state[6] | state[7],
                        state[5],
                        state[4],
                        state[3],
                        state[2],
                        state[1],
                        state[0] | state[8] | state[9],
                        1'b0};

    assign next_state = in ? next_if_1 : next_if_0;

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule
