module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    assign out = in[{sel, 2'b00} +: 4];

endmodule
