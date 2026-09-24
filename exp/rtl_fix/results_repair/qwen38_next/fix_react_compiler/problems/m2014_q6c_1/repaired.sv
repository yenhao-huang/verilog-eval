module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

// Y2: next state is B only from A with w = 0
assign Y2 = y[1] & ~w;

// Y4: next state is D from B, C, E, or F with w = 1
assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule
