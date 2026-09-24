module top_module (
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out
);

	// 8-bit wide 2-to-1 mux: sel = 0 -> a, sel = 1 -> b
	always @(*) begin
		out = sel ? b : a;
	end

endmodule
