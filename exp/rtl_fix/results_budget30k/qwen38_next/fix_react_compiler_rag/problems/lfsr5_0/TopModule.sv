module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

	reg [4:0] q_next;

	// Next-state logic (Galois LFSR: shift right, XOR feedback bit into taps 5 and 3)
	always @(*) begin
		q_next        = {1'b0, q[4:1]};   // shift right
		q_next[4]     = q[0];             // tap at bit position 5 (feedback into MSB)
		q_next[2]     = q_next[2] ^ q[0]; // tap at bit position 3
	end

	// State register with synchronous active-high reset
	always @(posedge clk) begin
		if (reset)
			q <= 5'h1;
		else
			q <= q_next;
	end

endmodule
