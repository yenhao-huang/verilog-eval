module top_module(
	input x,
	input y,
	output z);

    wire a, b;
    wire z_or, z_and;

    assign a = (x ^ y) & x;
    assign b = ~(x ^ y);

    assign z_or = a | b;
    assign z_and = a & b;

    assign z = z_or ^ z_and;

endmodule
