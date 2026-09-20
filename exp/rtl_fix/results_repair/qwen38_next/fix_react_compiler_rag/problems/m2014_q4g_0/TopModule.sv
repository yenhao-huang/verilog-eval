module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// XNOR(in1,in2) -> XOR with in3
	assign out = ~(in1 ^ in2) ^ in3;

endmodule
