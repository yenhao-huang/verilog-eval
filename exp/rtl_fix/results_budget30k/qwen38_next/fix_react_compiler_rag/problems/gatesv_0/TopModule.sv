module top_module (
	input [3:0] in,
	output [2:0] out_both,
	output [3:1] out_any,
	output [3:0] out_different
);

	// both current bit and the bit to the left (higher index) are 1
	assign out_both     = in[2:0] & in[3:1];

	// either current bit or the bit to the right (lower index) is 1
	assign out_any      = in[3:1] | in[2:0];

	// current bit differs from neighbour to the left, with wrap-around
	assign out_different = in ^ {in[0], in[3:1]};

endmodule
