module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // Neighbours of every cell; boundaries q[-1] and q[512] are 0.
    wire [511:0] left  = {1'b0, q[511:1]};   // left[i]  = q[i+1]
    wire [511:0] right = {q[510:0], 1'b0};   // right[i] = q[i-1]

    // Rule 110: next state is 0 only for {L,C,R} = 111, 100, 000
    wire [511:0] next_q = ~((left & q & right)      |
                            (left & ~q & ~right)    |
                            (~left & ~q & ~right));

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
