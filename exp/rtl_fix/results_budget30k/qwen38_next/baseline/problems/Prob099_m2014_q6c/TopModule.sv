module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

    // Y2 is the next-state signal for y[1], state B
    assign Y2 = y[0] & ~w;

    // Y4 is the next-state signal for y[3], state D
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
