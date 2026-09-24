module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // out must be 8 bits wide, otherwise the result is truncated to 1 bit
    assign out = sel ? b : a;

endmodule
