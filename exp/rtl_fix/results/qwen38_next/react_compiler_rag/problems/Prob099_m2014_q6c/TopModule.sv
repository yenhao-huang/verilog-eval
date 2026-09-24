module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is the next-state signal for state B, i.e. y[1]
    // State B is reached only from state A when w = 0
    assign Y1 = y[0] & ~w;

    // Y3 is the next-state signal for state D, i.e. y[3]
    // State D is reached from B, C, E, or F when w = 1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule
