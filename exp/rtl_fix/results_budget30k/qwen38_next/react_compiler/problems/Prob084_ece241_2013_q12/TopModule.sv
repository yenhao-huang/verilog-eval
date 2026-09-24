module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register: Q[0] is the first bit shifted in (MSB first),
    // and bits shift toward Q[7].
    reg [7:0] q;

    always @(posedge clk) begin
        if (enable) begin
            q <= {q[6:0], S};   // q[0] <= S, q[1] <= q[0], ..., q[7] <= q[6]
        end
    end

    // 8:1 multiplexer: ABC = 000 -> Q[0], 001 -> Q[1], ... 111 -> Q[7]
    assign Z = q[{A, B, C}];

endmodule
