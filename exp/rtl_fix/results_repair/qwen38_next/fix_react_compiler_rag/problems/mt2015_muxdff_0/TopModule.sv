module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

	// 1-bit 2-to-1 multiplexer feeding a D flip-flop:
	//   L = 1 -> load r_in
	//   L = 0 -> load q_in (feedback/shift value from full_module)
	always @(posedge clk) begin
		if (L)
			Q <= r_in;
		else
			Q <= q_in;
	end

endmodule
