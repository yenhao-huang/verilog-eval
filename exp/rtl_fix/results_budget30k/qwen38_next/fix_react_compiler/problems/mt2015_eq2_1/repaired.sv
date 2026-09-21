module top_module(
	input [1:0] A,
	input [1:0] B,
	output reg z);

	always @(*) z = (A == B);

endmodule
