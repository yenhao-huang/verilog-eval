module top_module (
	input [99:0] a,
	input [99:0] b,
	input sel,
	output [99:0] out
);

	// out is a wire (default net type), so it must be driven
	// with a continuous assignment, not a procedural (always) block.
	assign out = (sel == 1'b0) ? a : b;

endmodule
