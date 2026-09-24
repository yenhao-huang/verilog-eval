module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state bits: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    wire a = state[0];
    wire b = state[1];
    wire c = state[2];
    wire d = state[3];

    // Next-state logic (by inspection of the transition table)
    assign next_state[0] = (~in) & (a | c);      // -> A from A(in=0), C(in=0)
    assign next_state[1] =   in  & (a | b | d);  // -> B from A(in=1), B(in=1), D(in=1)
    assign next_state[2] = (~in) & (b | d);      // -> C from B(in=0), D(in=0)
    assign next_state[3] =   in  & c;            // -> D from C(in=1)

    // Moore output: asserted only in state D
    assign out = d;

endmodule
