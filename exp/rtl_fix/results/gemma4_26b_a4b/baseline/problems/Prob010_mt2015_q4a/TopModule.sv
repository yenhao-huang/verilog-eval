module TopModule (
    input x,
    input y,
    output z
);

    // The boolean function is z = (x ^ y) & x
    // x ^ y is the XOR operation
    // & is the AND operation
    assign z = (x ^ y) & x;

endmodule
