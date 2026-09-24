module top_module (
	input in1,
	input in2,
	output logic out
);

	// AND gate with a bubble on the in2 input: out = in1 AND (NOT in2)
	assign out = in1 & ~in2;

endmodule
