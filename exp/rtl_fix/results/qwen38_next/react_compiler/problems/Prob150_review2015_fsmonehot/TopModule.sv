module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // One-hot state encoding:
    // state[0] = S,     state[1] = S1,    state[2] = S11,   state[3] = S110,
    // state[4] = B0,    state[5] = B1,    state[6] = B2,    state[7] = B3,
    // state[8] = Count, state[9] = Wait

    // Next-state logic (by inspection of the state diagram)
    assign B3_next    = state[6];                                  // B2 -> B3

    assign S_next     = ((~d) & (state[0] | state[1] | state[3]))  // S,S1,S110 with d=0
                        | (ack & state[9]);                        // Wait with ack=1

    assign S1_next    = d & state[0];                              // S with d=1

    assign Count_next = state[7]                                   // B3 -> Count
                        | ((~done_counting) & state[8]);           // Count with done_counting=0

    assign Wait_next  = (done_counting & state[8])                 // Count with done_counting=1
                        | ((~ack) & state[9]);                     // Wait with ack=0

    // Moore output logic
    assign done       = state[9];                                  // Wait
    assign counting   = state[8];                                  // Count
    assign shift_ena  = state[4] | state[5] | state[6] | state[7]; // B0, B1, B2, B3

endmodule
