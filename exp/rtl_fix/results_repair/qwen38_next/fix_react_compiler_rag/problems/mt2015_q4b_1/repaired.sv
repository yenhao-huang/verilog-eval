module top_module(
	input x,
	input y,
	output z);

	wire xor_output;
	wire not_output;

	// XOR gate: output first, then inputs
	xor xor_gate(xor_output, x, y);

	// NOT gate: output first, then input
	not not_gate(not_output, xor_output);

	// Output
	assign z = not_output;

endmodule
