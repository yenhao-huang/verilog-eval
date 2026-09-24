module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // q[0] is treated as the leftmost cell:
    // left neighbor of q[i] is q[i-1], right neighbor is q[i+1].
    wire [511:0] left  = {q[510:0], 1'b0};
    wire [511:0] right = {1'b0, q[511:1]};

    // Rule 110:
    // next = 1 for 001, 010, 011, 101, 110
    wire [511:0] next_q =
        (~left & (q | right)) |
        (left & q & ~right) |
        (left & ~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
