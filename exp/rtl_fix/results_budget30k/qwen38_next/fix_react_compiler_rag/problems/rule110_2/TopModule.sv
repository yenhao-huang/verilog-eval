module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	// Neighbour vectors, boundaries q[-1] and q[512] are 0
	wire [511:0] left  = {1'b0, q[511:1]};  // q[i-1]
	wire [511:0] right = {q[510:0], 1'b0};  // q[i+1]

	always @(posedge clk) begin
		if (load)
			q <= data;
		else
			// Rule 110: next = (C ^ R) | (~L & (C | R))
			q <= (q ^ right) | (~left & (q | right));
	end
endmodule
