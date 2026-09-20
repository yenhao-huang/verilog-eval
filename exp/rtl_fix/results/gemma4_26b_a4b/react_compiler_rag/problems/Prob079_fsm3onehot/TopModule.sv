module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State Encoding:
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    // State Transition Table:
    // State | in=0 | in=1 | Output
    // A     | A    | B    | 0
    // B     | C    | B    | 0
    // C     | A    | D    | 0
    // D     | C    | B    | 1

    // Next State Logic derivation:
    // next_state[0] (A): (state[0] & ~in) | (state[2] & ~in)
    // next_state[1] (B): (state[0] & in) | (state[1] & in) | (state[3] & in)
    // next_state[2] (C): (state[1] & ~in) | (state[3] & ~in)
    // next_state[3] (D): (state[2] & in)

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    assign next_state[3] = (state[2] & in);

    // Output Logic (Moore machine: output depends only on current state):
    // Output is 1 only in state D (state[3])
    assign out = state[3];

endmodule
