module TopModule (
    input            clk,
    input            load,
    input  [511:0]   data,
    output reg [511:0] q
);

    // Rule 90: next state of each cell = XOR of its two neighbours.
    // Left neighbours  (q[i-1]) : {q[510:0], 1'b0}   (q[-1] = 0)
    // Right neighbours (q[i+1]) : {1'b0, q[511:1]}   (q[512] = 0)
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= ({q[510:0], 1'b0} ^ {1'b0, q[511:1]});
    end

endmodule
