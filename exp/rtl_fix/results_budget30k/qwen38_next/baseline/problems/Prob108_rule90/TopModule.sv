module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Rule 90:
    // next_q[i] = q[i-1] XOR q[i+1]
    // Boundaries: q[-1] = 0 and q[512] = 0
    assign next_q = {q[510:0], 1'b0} ^ {1'b0, q[511:1]};

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
