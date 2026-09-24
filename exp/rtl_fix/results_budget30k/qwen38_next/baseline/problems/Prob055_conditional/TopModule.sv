module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_reg;

    always @(*) begin
        min_reg = a;
        if (b < min_reg) min_reg = b;
        if (c < min_reg) min_reg = c;
        if (d < min_reg) min_reg = d;
    end

    assign min = min_reg;

endmodule
