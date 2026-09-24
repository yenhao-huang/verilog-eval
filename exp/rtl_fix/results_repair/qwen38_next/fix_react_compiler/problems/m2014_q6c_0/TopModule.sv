module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// Next-state logic (combinational), derived by inspection from the one-hot FSM
	// Y2: state B is entered only from A with w = 0
	assign Y2 = y[1] & ~w;

	// Y4: state D is entered from B, C, E, F with w = 1
	assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule
