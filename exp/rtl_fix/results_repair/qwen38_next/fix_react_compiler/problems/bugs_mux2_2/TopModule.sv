module top_module (
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out
);

	// 8-bit wide 2-to-1 multiplexer implemented directly (no submodule)
	always @(*) begin
		if (sel)
			out = b;
		else
			out = a;
	end

endmodule
