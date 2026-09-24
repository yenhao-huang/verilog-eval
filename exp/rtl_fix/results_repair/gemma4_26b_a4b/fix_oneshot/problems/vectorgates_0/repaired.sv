module top_module(
	input [2:0] a, 
	input [2:0] b, 
	output [2:0] out_or_bitwise,
	output out_or_logical,
	output [5:0] out_not
);

	// Perform bitwise OR of the two 3-bit vectors
	assign out_or_bitwise = a | b;
	
	// Perform logical OR of the two vectors (returns 1 if either is non-zero)
	assign out_or_logical = a || b;
	
	// Place the inverse of b in the upper half [5:3] and inverse of a in the lower half [2:0]
	// Using concatenation operator { }
	assign out_not = {~b, ~a};

endmodule
