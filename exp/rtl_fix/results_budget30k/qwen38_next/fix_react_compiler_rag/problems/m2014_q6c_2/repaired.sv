module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// One-hot states: A=y[1], B=y[2], C=y[3], D=y[4], E=y[5], F=y[6]

	// Next state B: only transition A --0--> B
	assign Y2 = y[1] & ~w;

	// Next state D: B --1--> D, C --1--> D, E --1--> D, F --1--> D
	assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule
