module TopModule (
    input a,
    input b,
    output out
);

    // An XNOR gate returns 1 if the inputs are the same, and 0 if they are different.
    // This can be implemented using the bitwise XNOR operator (~^) 
    // or by negating the XOR result ~(a ^ b).
    assign out = ~(a ^ b);

endmodule
