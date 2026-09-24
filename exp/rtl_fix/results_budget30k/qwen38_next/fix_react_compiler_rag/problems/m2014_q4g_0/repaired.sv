module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// XNOR of in1 and in2, then XOR with in3 (purely combinational)
	assign out = ~(in1 ^ in2) ^ in3;

endmodule
