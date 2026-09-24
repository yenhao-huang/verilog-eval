module top_module (
	input [7:0] in,
	output [7:0] out
);

  // Reverse the bit order of an 8-bit vector.
  // (SystemVerilog alternative: assign out = {<<8{in}};)
  assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
