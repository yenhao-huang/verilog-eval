module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge);

	reg [7:0] d_last;   // previous value of in (was missing -> caused the bind error)

	always @(posedge clk) begin
		d_last <= in;
		anyedge <= in ^ d_last;   // any 0->1 or 1->0 edge, one cycle later
	end

endmodule
