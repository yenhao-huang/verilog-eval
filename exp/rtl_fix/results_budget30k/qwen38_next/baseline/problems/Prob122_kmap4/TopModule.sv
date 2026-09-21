module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The Karnaugh map has 1s on odd-parity combinations of a, b, c, d.
    assign out = a ^ b ^ c ^ d;

endmodule
