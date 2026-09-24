module top_module (
	input a, 
	input b, 
	output q
);

	// Combinational logic: q = a AND b
	assign q = a & b;

endmodule
