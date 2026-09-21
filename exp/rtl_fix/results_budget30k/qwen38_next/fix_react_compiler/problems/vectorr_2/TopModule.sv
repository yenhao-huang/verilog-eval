module top_module (
	input [7:0] in,
	output [7:0] out
);

  // Reverse the bit order of the 8-bit input vector.
  // out[0] = in[7], out[1] = in[6], ..., out[7] = in[0]
  assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
