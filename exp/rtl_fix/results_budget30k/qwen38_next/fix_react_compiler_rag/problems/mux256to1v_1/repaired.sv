module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

    // Select 4 bits starting at bit position sel*4.
    // {sel, 2'b00} == sel*4, so this picks in[sel*4 +: 4]
    assign out = in[{sel, 2'b00} +: 4];

endmodule
