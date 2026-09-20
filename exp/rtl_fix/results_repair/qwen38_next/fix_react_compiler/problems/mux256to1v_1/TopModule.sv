module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

	// 256-to-1, 4-bit wide multiplexer (combinational).
	// sel selects a 4-bit slice starting at bit index sel*4.
	assign out = in[{sel, 2'b00} +: 4];

endmodule
