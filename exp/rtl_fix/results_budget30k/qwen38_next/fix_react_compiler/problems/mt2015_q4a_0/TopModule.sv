module top_module(
	input x,
	input y,
	output z);

	assign z = (x ^ y) & x;   // continuous assignment drives the wire z

endmodule
