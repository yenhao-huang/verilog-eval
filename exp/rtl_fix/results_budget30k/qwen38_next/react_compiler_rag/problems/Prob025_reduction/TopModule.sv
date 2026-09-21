module TopModule (
    input  [7:0] in,
    output       parity
);

    // Even parity: XOR reduction of all 8 data bits
    assign parity = ^in;

endmodule
