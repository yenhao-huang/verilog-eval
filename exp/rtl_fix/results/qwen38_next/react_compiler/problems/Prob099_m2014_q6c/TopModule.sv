module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // One-hot encoding:
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Y1 is the next-state signal for state B (y[1]).
    // The only transition into B is: A --0--> B
    assign Y1 = y[0] & ~w;

    // Y3 is the next-state signal for state D (y[3]).
    // Transitions into D are: B --1--> D, C --1--> D, E --1--> D, F --1--> D
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
