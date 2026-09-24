module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // A half adder implements the following logic:
    // sum = a XOR b
    // cout = a AND b
    
    assign sum = a ^ b;
    assign cout = a & b;

endmodule
