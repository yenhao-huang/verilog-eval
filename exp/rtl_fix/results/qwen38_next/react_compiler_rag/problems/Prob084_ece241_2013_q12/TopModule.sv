module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // 8-bit shift register: Q[0] is the first stage (S feeds Q[0]),
    // MSB is shifted in first so data moves Q[0] -> Q[1] -> ... -> Q[7].
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // 8:1 multiplexer implementing the 3-input logic function (LUT).
    assign Z = Q[{A, B, C}];

endmodule
