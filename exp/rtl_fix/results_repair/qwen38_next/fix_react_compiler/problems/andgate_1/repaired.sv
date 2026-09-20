module top_module(
	input a, 
	input b,
	output out
);

	// Continuous assignment instead of instantiating an undefined module
	assign out = a & b;

endmodule
