module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

// (1) out_both: Each bit indicates whether both the input bit and its neighbor to the left are '1'.
// For out_both[98], the neighbor to the left is in[99].
// Therefore, out_both[i] = in[i] & in[i+1].
assign out_both = in[98:0] & in[99:1];

// (2) out_any: Each bit indicates whether any of the input bit and its neighbor to the right are '1'.
// For out_any[2], the neighbor to the right is in[1].
// Therefore, out_any[i] = in[i] | in[i-1].
assign out_any = in[99:1] | in[98:0];

// (3) out_different: Each bit indicates whether the input bit is different from its neighbor to the left.
// The vector wraps around, so in[99]'s neighbor to the left is in[0].
// This means out_different[99] = in[99] ^ in[0].
// For other bits, out_different[i] = in[i] ^ in[i+1].
// We can achieve this using a rotation: {in[0], in[99:1]}.
assign out_different = in[99:0] ^ {in[0], in[99:1]};

endmodule
