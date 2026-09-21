module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

	// 5-bit maximal-length Galois LFSR, taps at bit positions 5 and 3.
	// Active-high synchronous reset loads 5'h1.
	always @(posedge clk) begin
		if (reset) begin
			q <= 5'h1;
		end
		else begin
			// q_next[4]   = q[0]            (tap: bit position 5)
			// q_next[3]   = q[4]
			// q_next[2]   = q[3] ^ q[0]     (tap: bit position 3)
			// q_next[1]   = q[2]
			// q_next[0]   = q[1]
			q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
		end
	end

endmodule
