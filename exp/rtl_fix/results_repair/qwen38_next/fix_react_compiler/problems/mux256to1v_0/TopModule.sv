module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

	// Purely combinational 256-to-1, 4-bit wide multiplexer.
	// sel = 0 -> in[3:0], sel = 1 -> in[7:4], ... sel = 255 -> in[1023:1020]
	assign out = in[{sel, 2'b00} +: 4];   // equivalent to in[sel*4 +: 4]

endmodule
