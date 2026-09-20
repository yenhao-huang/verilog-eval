module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // The goal is to reverse the byte order of the 32-bit vector.
    // A 32-bit vector consists of 4 bytes:
    // Byte 3: bits [31:24]
    // Byte 2: bits [23:16]
    // Byte 1: bits [15:8]
    // Byte 0: bits [7:0]
    //
    // Reversing the byte order means:
    // out[31:24] = in[7:0]
    // out[23:16] = in[15:8]
    // out[15:8]  = in[23:16]
    // out[7:0]   = in[31:24]

    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule
