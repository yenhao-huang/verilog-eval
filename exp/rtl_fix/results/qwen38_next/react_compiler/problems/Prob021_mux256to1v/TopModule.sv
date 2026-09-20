module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Byte address -> bit offset: sel * 4
    wire [9:0] sel4 = {sel, 2'b00};

    // Variable part-select: in[sel*4 +: 4]
    assign out = in[sel4 +: 4];

endmodule
