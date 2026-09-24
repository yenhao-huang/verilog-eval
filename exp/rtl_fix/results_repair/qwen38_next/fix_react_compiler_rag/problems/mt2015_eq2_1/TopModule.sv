module top_module(
	input [1:0] A,
	input [1:0] B,
	output z);

  // Combinational 2-bit equality comparator:
  // z = 1 when A == B, otherwise z = 0
  assign z = (A == B);

endmodule
