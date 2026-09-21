module top_module(
	input [1:0] A,
	input [1:0] B,
	output z);

    // Combinational equality comparator: z = 1 when A == B
    assign z = (A == B);

endmodule
