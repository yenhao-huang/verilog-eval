module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // sel * 4 gives the starting bit index of the selected 4-bit chunk
    assign out = in[{sel, 2'b00} +: 4];

endmodule
