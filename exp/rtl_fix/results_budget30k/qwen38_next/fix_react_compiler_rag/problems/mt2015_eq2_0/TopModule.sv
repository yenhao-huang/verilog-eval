module top_module(
	input [1:0] A,
	input [1:0] B,
	output z);

  // z is an implicit 1-bit net declared by the port list,
  // so drive it with a continuous assignment (no re-declaration, no clock).
  assign z = (A == B) ? 1'b1 : 1'b0;

endmodule
