module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // One-hot state encoding:
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Y1 is the next-state input for flip-flop y[1], i.e. next state B.
    // State B is entered only from A when w = 1.
    assign Y1 = w & y[0];

    // Y3 is the next-state input for flip-flop y[3], i.e. next state D.
    // State D is entered from B, C, E, or F when w = 0.
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
