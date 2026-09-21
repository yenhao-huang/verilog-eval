module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot encoding: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    //
    // Flip-flop y[1] (state B) is entered only from A when w = 1
    assign Y1 = y[0] & w;

    // Flip-flop y[3] (state D) is entered from B, C, E, or F when w = 0
    // (D itself goes to A on w=0 and to F on w=1, so it is not included)
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
