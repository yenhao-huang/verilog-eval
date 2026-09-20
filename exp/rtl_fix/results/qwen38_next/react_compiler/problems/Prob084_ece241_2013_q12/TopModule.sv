module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register: S feeds Q[0]; Q[0] shifts into Q[1], etc.
    reg [7:0] q;

    always @(posedge clk) begin
        if (enable) begin
            q <= {q[6:0], S};
        end
    end

    // 8:1 multiplexer selected by ABC (ABC = 000 -> Q[0], ..., 111 -> Q[7])
    assign Z = q[{A, B, C}];

endmodule
