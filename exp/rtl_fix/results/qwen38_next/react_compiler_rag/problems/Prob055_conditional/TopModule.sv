module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_r;

    always @(*) begin
        min_r = a;
        if (b < min_r) min_r = b;
        if (c < min_r) min_r = c;
        if (d < min_r) min_r = d;
    end

    assign min = min_r;

endmodule
