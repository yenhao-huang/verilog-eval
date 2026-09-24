module top_module (
	input [99:0] a,
	input [99:0] b,
	input sel,
	output [99:0] out
);

	// sel = 0 -> select a, sel = 1 -> select b
	assign out = sel ? b : a;

endmodule
