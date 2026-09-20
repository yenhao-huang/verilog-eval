module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // q is 1 when the number of 1s among a,b,c,d is even
    assign q = ~(a ^ b ^ c ^ d);

endmodule
