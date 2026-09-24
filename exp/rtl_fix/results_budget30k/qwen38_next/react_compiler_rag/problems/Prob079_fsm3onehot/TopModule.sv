module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state decoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    wire a = state[0];
    wire b = state[1];
    wire c = state[2];
    wire d = state[3];

    // Next-state logic by inspection of the transition table:
    //  A is reached from A (in=0) and C (in=0)
    assign next_state[0] = (~in) & (a | c);

    //  B is reached from A (in=1), B (in=1), and D (in=1)
    assign next_state[1] = in & (a | b | d);

    //  C is reached from B (in=0) and D (in=0)
    assign next_state[2] = (~in) & (b | d);

    //  D is reached from C (in=1)
    assign next_state[3] = in & c;

    // Moore output: 1 only in state D
    assign out = d;

endmodule
