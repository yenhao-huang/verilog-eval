module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Next state B occurs only from state A when w = 1
    assign Y1 = y[0] & w;

    // Next state D occurs from B, C, E, or F when w = 0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
