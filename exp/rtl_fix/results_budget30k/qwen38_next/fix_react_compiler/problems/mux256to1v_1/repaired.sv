module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

	// Start bit of the selected 4-bit channel is sel*4 == {sel, 2'b00}
	assign out = in[{sel, 2'b00} +: 4];   // equivalent: in[sel*4 +: 4]

endmodule
