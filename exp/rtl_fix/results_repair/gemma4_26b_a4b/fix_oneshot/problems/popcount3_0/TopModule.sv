module top_module (
	input [2:0] in,
	output [1:0] out
);

	// The population count of a 3-bit vector can be calculated by 
	// simply summing the individual bits. The sum of three 1-bit 
	// values ranges from 0 to 3, which fits perfectly into a 2-bit output.
	assign out = in[2] + in[1] + in[0];

endmodule
