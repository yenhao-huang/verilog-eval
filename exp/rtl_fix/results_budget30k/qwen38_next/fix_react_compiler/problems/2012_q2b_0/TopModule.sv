module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

	// Y1: next-state for flip-flop y[1] (state B)
	//     A --w=1--> B
	assign Y1 = y[0] & w;

	// Y3: next-state for flip-flop y[3] (state D)
	//     B --0--> D, C --0--> D, E --0--> D, F --0--> D
	assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule
