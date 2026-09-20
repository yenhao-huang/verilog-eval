module TopModule (
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

    // One-hot state encoding:
    // state[0] = S
    // state[1] = S1
    // state[2] = S11
    // state[3] = S110
    // state[4] = B0
    // state[5] = B1
    // state[6] = B2
    // state[7] = B3
    // state[8] = Count
    // state[9] = Wait

    // Next-state logic
    assign S_next     = (~d & (state[0] | state[1] | state[3])) | (ack & state[9]);
    assign S1_next    = d & state[0];
    assign B3_next    = state[6];
    assign Count_next = state[7] | (~done_counting & state[8]);
    assign Wait_next  = (done_counting & state[8]) | (~ack & state[9]);

    // Moore output logic
    assign done       = state[9];
    assign counting   = state[8];
    assign shift_ena  = state[4] | state[5] | state[6] | state[7];

endmodule
