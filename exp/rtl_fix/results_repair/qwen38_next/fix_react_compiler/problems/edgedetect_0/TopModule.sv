module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

	// FIX: d_last was used but never declared -> declare it as an 8-bit reg
	reg [7:0] d_last;

	// No reset port exists, so give the state a defined start value
	initial begin
		d_last = 8'h00;
		pedge  = 8'h00;
	end

	always @(posedge clk) begin
		d_last <= in;                 // save previous value of in
		pedge  <= in & ~d_last;       // 0 -> 1 transition detected
	end

endmodule
