module TopModule (
    input x,
    input y,
    output z
);

    // Based on the provided simulation waveform, we can derive the truth table:
    // x | y | z
    // --|---|--
    // 0 | 0 | 1
    // 1 | 0 | 0
    // 0 | 1 | 0
    // 1 | 1 | 1
    //
    // This truth table corresponds to the XNOR logic operation.
    // z = ~(x ^ y) or z = (x == y)

    assign z = ~(x ^ y);

endmodule
