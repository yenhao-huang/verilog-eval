module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	wire [511:0] left;   // left neighbor of cell i is q[i+1], q[512] = 0
	wire [511:0] right;  // right neighbor of cell i is q[i-1], q[-1] = 0
	wire [511:0] next_q;

	assign left  = {1'b0, q[511:1]};
	assign right = {q[510:0], 1'b0};

	// Rule 110: next = 1 for 110, 101, 011, 010, 001 ; next = 0 for 111, 100, 000
	assign next_q = (left & q & ~right) |   // 110
	                (~left & q)           |   // 011 and 010
	                (~q & right);             // 101 and 001

	always @(posedge clk) begin
		if (load)
			q <= data;
		else
			q <= next_q;
	end

endmodule
