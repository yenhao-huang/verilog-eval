module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// One-hot encoding: y[1]=A, y[2]=B, y[3]=C, y[4]=D, y[5]=E, y[6]=F
	// (y[0] does not exist in this declaration — that was the error)

	// Next state B: only from A when w = 0
	assign Y2 = ~w & y[1];

	// Next state D: from B, C, E, or F when w = 1
	assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule
