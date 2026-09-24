module top_module (
	input [99:0] a,
	input [99:0] b,
	input sel,
	output [99:0] out
);

	// Combinational 2-1 mux: sel = 0 -> a, sel = 1 -> b
	assign out = sel ? b : a;

endmodule
