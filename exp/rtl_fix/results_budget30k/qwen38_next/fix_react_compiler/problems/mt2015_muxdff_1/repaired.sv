module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

    // One bit of the LFSR: 2-to-1 mux feeding a D flip-flop.
    // L = 1 -> load r_in (parallel load)
    // L = 0 -> shift/feedback from q_in
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule
