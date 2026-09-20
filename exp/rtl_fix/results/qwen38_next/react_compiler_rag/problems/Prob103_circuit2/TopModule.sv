module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    // q is 1 when an even number of inputs are high (even parity / 4-input XNOR)
    assign q = ~(a ^ b ^ c ^ d);

endmodule
