module TopModule (
    input            clk,
    input            load,
    input  [511:0]   data,
    output reg [511:0] q
);

    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] next_q;

    // left[i]  = q[i+1], with imaginary q[512] = 0
    // right[i] = q[i-1], with imaginary q[-1]  = 0
    assign left  = {1'b0, q[511:1]};
    assign right = {q[510:0], 1'b0};

    // Rule 110 next-state function:
    //   next = (center & ~(left & right)) | (~center & right)
    assign next_q = (q & ~(left & right)) | (~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
