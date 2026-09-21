module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

	// intermediate signal: output of the XNOR gate
	logic xnor_out;

	// XNOR of in1 and in2
	assign xnor_out = ~(in1 ^ in2);   // equivalent to: xnor x1(xnor_out, in1, in2);

	// XOR of the XNOR result with in3
	assign out = xnor_out ^ in3;      // equivalent to: xor  x2(out, xnor_out, in3);

endmodule
