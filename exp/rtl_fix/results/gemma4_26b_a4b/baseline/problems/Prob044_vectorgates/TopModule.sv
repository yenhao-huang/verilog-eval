module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of the two 3-bit vectors
    assign out_or_bitwise = a | b;

    // Logical OR of the two vectors
    // In Verilog, the || operator treats a multi-bit vector as true if any bit is 1
    assign out_or_logical = a || b;

    // Inverse (NOT) of both vectors
    // The inverse of b is placed in the upper half [5:3]
    // The inverse of a is placed in the lower half [2:0]
    assign out_not = {~b, ~a};

endmodule
