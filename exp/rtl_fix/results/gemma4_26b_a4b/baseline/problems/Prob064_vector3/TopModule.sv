module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // The description specifies that the input vectors (a, b, c, d, e, f) 
    // should be concatenated together, followed by two 1 bits at the LSB positions.
    // Total bits = (6 * 5) + 2 = 32 bits.
    // These 32 bits are then split into four 8-bit output vectors (w, x, y, z).
    
    // In Verilog, the concatenation operator { } allows us to group the 
    // inputs and the constant 2'b11 into a single 32-bit vector.
    // We then assign this 32-bit vector to the concatenated output ports {w, x, y, z}.
    
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
