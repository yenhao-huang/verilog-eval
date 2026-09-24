module top_module (
	input [99:0] in,
	output out_and,
	output out_or,
	output out_xor
);

	// Reduction operators: fold all 100 bits into a single bit
	assign out_and = &in;   // 100-input AND
	assign out_or  = |in;   // 100-input OR
	assign out_xor = ^in;   // 100-input XOR

endmodule
