module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // Neighbour vectors: left[i]  = q[i+1] (q[512] = 0)
    //                    right[i] = q[i-1] (q[-1]  = 0)
    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_q;

    assign left  = {1'b0, q[511:1]};
    assign right = {q[510:0], 1'b0};

    // Rule 110: next = 1 for LCR = 110, 101, 011, 010, 001
    assign next_q = (left &  q & ~right) |   // 110
                    (left & ~q &  right) |   // 101
                    (~left &  q) |           // 010, 011
                    (~left & ~q & right);    // 001

    always @(posedge clk) begin
        if (load)
            q <= data;      // synchronous active-high load
        else
            q <= next_q;    // advance one time step
    end
endmodule
