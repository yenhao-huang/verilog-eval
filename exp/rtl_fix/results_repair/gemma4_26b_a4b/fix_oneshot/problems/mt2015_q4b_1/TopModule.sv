module top_module(
	input x,
	input y,
	output z);

wire xor_output;
wire not_output;

// XOR gate
// Corrected syntax: Gate primitives in Verilog use positional arguments, not named ports.
// The syntax is: gate_type instance_name (output, input1, input2, ...);
xor xor_gate(
	xor_output,
	x,
	y
);

// NOT gate
// Corrected syntax: Gate primitives in Verilog use positional arguments.
not not_gate(
	not_output,
	xor_output
);

// Output
assign z = not_output;

endmodule
