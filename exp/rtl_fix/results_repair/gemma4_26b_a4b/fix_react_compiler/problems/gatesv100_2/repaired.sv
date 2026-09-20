module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

// (1) out_both[i] = in[i] & in[i+1]
// out_both[98] = in[98] & in[99]
// out_both[0] = in[0] & in[1]
assign out_both = in[98:0] & in[99:1];

// (2) out_any[i] = in[i] | in[i-1]
// out_any[99] = in[99] | in[98]
// out_any[1] = in[1] | in[0]
assign out_any = in[99:1] | in[98:0];

// (3) out_different[i] = in[i] ^ in[neighbor_to_the_left]
// neighbor_to_the_left of in[99] is in[0]
// neighbor_to_the_left of in[i] is in[(i+1)%100]
// out_different[99] = in[99] ^ in[0]
// out_different[98] = in[98] ^ in[99]
// out_different[0] = in[0] ^ in[1]
assign out_different = in ^ {in[0], in[99:1]};

endmodule
