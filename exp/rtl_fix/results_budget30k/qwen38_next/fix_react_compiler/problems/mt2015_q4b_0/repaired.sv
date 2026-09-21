module top_module(
	input x,
	input y,
	output z);

	// z is high when x and y are equal (XNOR)
	assign z = ~(x ^ y);

endmodule
