module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	// Missing declaration in the erroneous version:
	// previous value of "in", must be a reg since it is
	// assigned inside a sequential always block.
	reg [7:0] d_last = 8'h00;

	always @(posedge clk) begin
		d_last <= in;                 // save previous cycle's input
		pedge  <= in & ~d_last;       // 0 -> 1 transition detection
	end

endmodule
