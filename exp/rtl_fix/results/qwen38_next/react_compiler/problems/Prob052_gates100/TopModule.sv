module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Reduction operators perform the bitwise operation across all 100 bits
    assign out_and = &in;   // 100-input AND gate
    assign out_or  = |in;   // 100-input OR  gate
    assign out_xor = ^in;   // 100-input XOR gate

endmodule
