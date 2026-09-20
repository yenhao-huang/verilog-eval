module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // The output z is 1 if A is equal to B, otherwise it is 0.
    assign z = (A == B);

endmodule
