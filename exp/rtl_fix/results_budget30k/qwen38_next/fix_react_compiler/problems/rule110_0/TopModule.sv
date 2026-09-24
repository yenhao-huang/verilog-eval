module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

	// Neighbour vectors (boundaries q[512] and q[-1] are zero)
	wire [511:0] left  = {1'b0, q[511:1]};  // bit i = q[i+1]
	wire [511:0] right = {q[510:0], 1'b0};  // bit i = q[i-1]

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end
		else begin
			// Rule 110: next state is 0 only for 111, 100 and 000
			q <= ~( ( left  &  q  &  right) |
			        (~left  & ~q  & ~right) |
			        ( left  & ~q  & ~right) );
		end
	end
endmodule
