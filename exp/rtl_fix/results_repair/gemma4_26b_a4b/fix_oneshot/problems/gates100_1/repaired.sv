module top_module (
	input [99:0] in,
	output out_and,
	output out_or,
	output out_xor
);

	// Use reduction operators to implement the 100-input gates.
	// Reduction operators (&, |, ^) take a vector and reduce it to a single bit 
	// by applying the operator between all bits of the vector.
	assign out_and = &in;
	assign out_or  = |in;
	assign out_xor = ^in;

endmodule
