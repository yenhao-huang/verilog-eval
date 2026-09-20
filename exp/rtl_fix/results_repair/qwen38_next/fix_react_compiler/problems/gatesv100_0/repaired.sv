module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

	// both the bit and its left neighbour (higher index) are 1
	assign out_both = in[99:1] & in[98:0];

	// either the bit or its right neighbour (lower index) is 1
	assign out_any = in[99:1] | in[98:0];

	// bit differs from its left neighbour, wrapping in[99] <-> in[0]
	assign out_different = in ^ {in[0], in[99:1]};

endmodule
