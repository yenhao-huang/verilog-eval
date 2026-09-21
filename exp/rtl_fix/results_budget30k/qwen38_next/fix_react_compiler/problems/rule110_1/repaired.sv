module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	// Neighbour vectors (zero boundaries):
	//   left[i]  = q[i-1],  with q[-1]  = 0
	//   right[i] = q[i+1],  with q[512] = 0
	wire [511:0] left  = {q[510:0], 1'b0};
	wire [511:0] right = {1'b0, q[511:1]};

	// Rule 110: next = (C & ~(L & R)) | (~C & R)
	wire [511:0] q_next = (q & ~(left & right)) | (~q & right);

	always @(posedge clk) begin
		if (load)
			q <= data;      // synchronous active-high load
		else
			q <= q_next;    // advance one time step
	end

endmodule
