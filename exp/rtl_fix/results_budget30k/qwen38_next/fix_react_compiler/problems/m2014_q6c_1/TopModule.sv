module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

    // State B is entered only from state A when w == 0
    assign Y2 = y[1] & ~w;

    // State D is entered from B, C, E, or F when w == 1
    assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule
