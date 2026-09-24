module top_module (
	input [99:0] in,
	output out_and,
	output out_or,
	output out_xor
);

	// The problem asks for a combinational circuit.
	// Reduction operators (&, |, ^) are used to perform the operation 
	// across all bits of the input vector.
	assign out_and = &in;
	assign out_or  = |in;
	assign out_xor = ^in;

endmodule
