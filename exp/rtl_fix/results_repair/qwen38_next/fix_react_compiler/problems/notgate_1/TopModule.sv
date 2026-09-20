module top_module(
	input in,
	output out
);

	// Continuous assignment drives the wire output combinationally
	assign out = ~in;

endmodule
