module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

    // Select the 4-bit slice starting at bit 4*sel
    assign out = in[{sel, 2'b00} +: 4];   // same as in[sel*4 +: 4]

endmodule
