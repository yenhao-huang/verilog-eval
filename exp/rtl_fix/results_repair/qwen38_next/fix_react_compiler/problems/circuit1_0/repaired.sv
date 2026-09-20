module top_module (
	input a, 
	input b, 
	output q
);

	// Combinational circuit: q is high only when a and b are both high (AND gate)
	assign q = a & b;

endmodule
