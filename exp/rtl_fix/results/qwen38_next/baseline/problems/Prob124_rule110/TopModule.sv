module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_q;

    // left neighbor is q[i+1], with boundary q[512] = 0
    assign left  = {1'b0, q[511:1]};

    // right neighbor is q[i-1], with boundary q[-1] = 0
    assign right = {q[510:0], 1'b0};

    // Rule 110 next-state logic:
    // next = 1 for input combinations 001, 010, 011, 101, 110
    assign next_q = (left & q & ~right) |
                    (~left & (q | right)) |
                    (left & ~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
