module top_module (
	input a,
	input b,
	input sel,
	output out
);

	// Combinational 2-to-1 multiplexer: sel=0 -> a, sel=1 -> b
	assign out = sel ? b : a;

endmodule
