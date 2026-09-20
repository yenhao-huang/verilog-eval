module top_module (
	input [7:0] in,
	output [7:0] out
);

	// Continuous assignment: out is a wire, so it must be driven with assign
	assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
