module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	// Neighbours (boundaries q[512] and q[-1] are 0)
	wire [511:0] left  = {q[510:0], 1'b0};   // left[i]  = q[i+1]
	wire [511:0] right = {1'b0, q[511:1]};   // right[i] = q[i-1]

	// Rule 110: next = 1 for LCR = 001,010,011,101,110
	wire [511:0] next_q = (~left & q) | (~left & right) | (~q & right) | (q & ~right);

	always @(posedge clk) begin
		if (load)
			q <= data;
		else
			q <= next_q;
	end
endmodule
