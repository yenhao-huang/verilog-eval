module top_module(
	input x,
	input y,
	output z);

	wire xor_output;
	wire not_output;

	// XOR gate: primitive gates use positional connections (output first)
	xor xor_gate(xor_output, x, y);

	// NOT gate: positional connection (output first)
	not not_gate(not_output, xor_output);

	// Output  (z = XNOR(x, y))
	assign z = not_output;

endmodule
