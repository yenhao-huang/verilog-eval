module top_module (
	input [3:0] in,
	output [2:0] out_both,
	output [3:1] out_any,
	output [3:0] out_different
);

	// (1) out_both: Each bit indicates if the input bit and its left neighbor (higher index) are both '1'.
	// out_both[2] = in[2] & in[3]
	// out_both[1] = in[1] & in[2]
	// out_both[0] = in[0] & in[1]
	assign out_both = in[2:0] & in[3:1];

	// (2) out_any: Each bit indicates if the input bit and its right neighbor (lower index) are '1'.
	// out_any[3] = in[3] | in[2]
	// out_any[2] = in[2] | in[1]
	// out_any[1] = in[1] | in[0]
	assign out_any = in[3:1] | in[2:0];

	// (3) out_different: Each bit indicates if the input bit is different from its left neighbor (higher index),
	// with wrapping around (in[3]'s left neighbor is in[0]).
	// out_different[3] = in[3] ^ in[0]
	// out_different[2] = in[2] ^ in[3]
	// out_different[1] = in[1] ^ in[2]
	// out_different[0] = in[0] ^ in[1]
	// This can be achieved by XORing 'in' with a circularly shifted version of 'in'.
	assign out_different = in ^ {in[0], in[3:1]};

endmodule
