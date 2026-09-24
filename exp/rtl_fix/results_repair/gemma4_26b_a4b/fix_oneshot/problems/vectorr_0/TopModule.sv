module top_module (
	input [7:0] in,
	output [7:0] out
);

	// To reverse the bit ordering, we concatenate the bits of the input 
	// in the opposite order. 
	// The MSB of 'out' (out[7]) will be the LSB of 'in' (in[0]), 
	// and the LSB of 'out' (out[0]) will be the MSB of 'in' (in[7]).
	assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
