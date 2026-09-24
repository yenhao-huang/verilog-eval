module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	// y[1] (state B) is entered only from A when w = 1
	assign Y1 = y[0] & w;

	// y[3] (state D) is entered from B, C, E, or F when w = 0
	assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule
