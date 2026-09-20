module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

// (1) out_both: Each bit indicates whether both the corresponding input bit and its neighbour to the left are '1'.
// For bit i, the neighbour to the left is i+1.
// out_both[98] = in[98] & in[99]
// out_both[0] = in[0] & in[1]
assign out_both = in[98:0] & in[99:1];

// (2) out_any: Each bit indicates whether any of the corresponding input bit and its neighbour to the right are '1'.
// For bit i, the neighbour to the right is i-1.
// out_any[99] = in[99] | in[98]
// out_any[1] = in[1] | in[0]
assign out_any = in[99:1] | in[98:0];

// (3) out_different: Each bit indicates whether the corresponding input bit is different from its neighbour to the left.
// The vector wraps around, so in[99]'s neighbour to the left is in[0].
// out_different[99] = in[99] ^ in[0]
// out_different[98] = in[98] ^ in[99]
// out_different[0] = in[0] ^ in[1]
assign out_different = in ^ {in[0], in[99:1]};

endmodule
