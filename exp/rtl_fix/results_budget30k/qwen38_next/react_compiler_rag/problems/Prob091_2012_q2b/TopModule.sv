module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is the next-state input for flip-flop y[1] (state B).
    // State B is entered only from state A when w = 1.
    assign Y1 = y[0] & w;

    // Y3 is the next-state input for flip-flop y[3] (state D).
    // State D is entered from B, C, E, or F when w = 0.
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
