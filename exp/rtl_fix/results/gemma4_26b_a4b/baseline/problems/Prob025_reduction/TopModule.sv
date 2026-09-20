module TopModule (
    input [7:0] in,
    output parity
);

    // Even parity is calculated by XORing all the bits of the input.
    // The reduction XOR operator '^' in Verilog performs this operation 
    // across all bits of the vector.
    assign parity = ^in;

endmodule
