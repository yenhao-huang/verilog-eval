module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

    reg [4:0] q_next;

    always @(*) begin
        // shift right by one (default behavior: no tap)
        q_next = q[4:1];
        // tap at bit position 5 -> feedback bit enters the MSB
        q_next[4] = q[0];
        // tap at bit position 3 -> shifted value XORed with feedback bit
        q_next[2] = q[3] ^ q[0];
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'h1;
        else
            q <= q_next;
    end

endmodule
