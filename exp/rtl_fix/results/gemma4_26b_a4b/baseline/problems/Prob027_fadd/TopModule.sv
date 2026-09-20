module TopModule (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // The sum is calculated by XORing all three input bits
    assign sum = a ^ b ^ cin;

    // The carry-out is calculated by checking if at least two inputs are 1
    // Logic: (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & (a ^ b));

endmodule
