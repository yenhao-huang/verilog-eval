module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// Declare an intermediate signal to hold the result of the XNOR operation
	logic xnor_out;

	// Implement the XNOR operation: ~(in1 ^ in2)
	assign xnor_out = ~(in1 ^ in2);

	// Implement the XOR operation using the result of the XNOR and in3
	assign out = xnor_out ^ in3;

endmodule
