module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge);

	// Internal state: previous value of in (this declaration was missing)
	reg [7:0] d_last = 8'h00;

	always @(posedge clk) begin
		d_last <= in;              // save current input for next cycle
		anyedge <= in ^ d_last;    // 1 where any edge (0->1 or 1->0) occurred
	end

endmodule
