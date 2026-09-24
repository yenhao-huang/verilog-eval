module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

// (1) out_both: Each bit indicates whether both the corresponding input bit 
// and its neighbour to the left (in[i+1]) are '1'.
// out_both[i] = in[i] & in[i+1].
assign out_both = in[98:0] & in[99:1];

// (2) out_any: Each bit indicates whether any of the corresponding input bit 
// and its neighbour to the right (in[i-1]) are '1'.
// out_any[i] = in[i] | in[i-1].
assign out_any = in[99:1] | in[98:0];

// (3) out_different: Each bit indicates whether the corresponding input bit 
// is different from its neighbour to the left (in[i+1] with wrap-around).
// out_different[i] = in[i] ^ in[i+1] (where in[100] is in[0]).
assign out_different = in ^ {in[0], in[99:1]};

endmodule
