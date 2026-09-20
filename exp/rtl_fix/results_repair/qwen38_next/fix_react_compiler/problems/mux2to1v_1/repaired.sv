module top_module (
	input [99:0] a,
	input [99:0] b,
	input sel,
	output reg [99:0] out
);

	always @(*)
		out = (sel == 1'b0) ? a : b;

endmodule
