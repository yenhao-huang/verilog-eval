module top_module (
	input [7:0] in,
	output [7:0] out
);

	// Bit-reverse the 8-bit input (purely combinational, no clock needed).
	// out must be driven with a continuous assignment because it is a wire.
	assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
