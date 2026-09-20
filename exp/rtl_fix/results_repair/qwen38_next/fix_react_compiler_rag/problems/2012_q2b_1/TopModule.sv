module top_module (
	input [5:0] y,
	input w,
	output Y1,
	output Y3
);

// Next state B is reached only from A (y[0]) when w = 1
assign Y1 = y[0] & w;

// Next state D is reached from B, C, D, E, F when w = 0
// (part select written in descending order: y[5:1])
assign Y3 = |y[5:1] & ~w;

endmodule
