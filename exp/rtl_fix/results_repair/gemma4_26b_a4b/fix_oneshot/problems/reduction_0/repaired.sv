module top_module (
	input [7:0] in,
	output parity
);

	// The problem asks for even parity, which is the XOR of all bits.
	// In Verilog, the reduction XOR operator '^' computes the XOR of all bits in a vector.
	// Since no clock was provided in the module definition, the circuit should be combinational.
	assign parity = ^in;

endmodule
