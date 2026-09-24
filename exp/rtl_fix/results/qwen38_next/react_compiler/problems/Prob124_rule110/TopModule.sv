module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_q;

    // left[i]  = q[i+1], with q[512] = 0
    // right[i] = q[i-1], with q[-1]  = 0
    assign left  = {1'b0, q[511:1]};
    assign right = {q[510:0], 1'b0};

    // Rule 110:
    // If center is 1, next is 1 unless both neighbors are 1.
    // If center is 0, next is equal to the right neighbor.
    assign next_q = (q & ~(left & right)) | (~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
