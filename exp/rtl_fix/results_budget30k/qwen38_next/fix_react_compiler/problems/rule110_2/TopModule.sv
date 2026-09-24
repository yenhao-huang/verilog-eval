module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    // Neighbors with zero boundaries: q[-1] = 0, q[512] = 0
    wire [511:0] left  = {q[510:0], 1'b0};   // left[i]  = q[i-1]
    wire [511:0] right = {1'b0, q[511:1]};   // right[i] = q[i+1]

    // Rule 110: next = 1 for patterns 001, 010, 011, 101, 110
    wire [511:0] q_next = (~left & q) |          // 010, 011
                          (~q & right) |         // 001, 101
                          (left & q & ~right);   // 110

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

endmodule
