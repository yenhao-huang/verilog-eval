module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot encoding:
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Y1 is the next-state signal for state B (y[1]).
    // B is reached only from A when w = 0.
    assign Y1 = (~w) & y[0];

    // Y3 is the next-state signal for state D (y[3]).
    // D is reached from B, C, E, or F when w = 1.
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
