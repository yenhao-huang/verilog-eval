module top_module(
	input x,
	input y,
	output z);

wire xor_output;
wire not_output;

// XOR gate
// The first argument is the output, followed by the inputs.
xor xor_gate(
	xor_output,
	x,
	y
);

// NOT gate
// The first argument is the output, followed by the input.
not not_gate(
	not_output,
	xor_output
);

// Output
assign z = not_output;

endmodule
