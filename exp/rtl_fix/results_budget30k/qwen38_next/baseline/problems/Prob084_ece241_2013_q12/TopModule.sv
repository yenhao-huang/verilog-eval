module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register: q[0] corresponds to Q[0], ..., q[7] corresponds to Q[7]
    reg [7:0] q;

    // Synchronous shift register with active-high enable.
    // S enters q[0] and shifts toward q[7].
    always @(posedge clk) begin
        if (enable) begin
            q <= {q[6:0], S};
        end
    end

    // 8:1 multiplexer selecting Q[ABC]
    assign Z = q[{A, B, C}];

endmodule
