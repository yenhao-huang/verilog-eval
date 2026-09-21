module top_module (
	input [6:1] y,
	input w,
	output Y2,
	output Y4
);

	// One-hot encoding: y[1]=A, y[2]=B, y[3]=C, y[4]=D, y[5]=E, y[6]=F
	// Y2: A --0--> B
	assign Y2 = y[1] & ~w;

	// Y4: B --1--> D, C --1--> D, E --1--> D, F --1--> D
	assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule
