module top_module (
	input [7:0] in,
	output [7:0] out
);

	// To reverse the bit ordering, we concatenate the bits of 'in' in reverse order.
	// The concatenation operator { } places the first element in the most significant position.
	// Thus, in[0] becomes out[7], in[1] becomes out[6], ..., and in[7] becomes out[0].
	assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
