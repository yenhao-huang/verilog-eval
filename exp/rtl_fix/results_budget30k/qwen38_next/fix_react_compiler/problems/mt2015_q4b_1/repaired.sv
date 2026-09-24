module top_module(
	input x,
	input y,
	output z);

    // z is 1 when x and y are equal (XNOR of the two inputs)
    assign z = ~(x ^ y);

endmodule
