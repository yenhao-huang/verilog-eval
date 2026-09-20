module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

// TopModule: implements a 4-bit ripple carry adder
module TopModule (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Internal wires to carry the signal between full adders
    wire c1, c2, c3;

    // Instantiate 4 full adders
    // Stage 0: First bit addition (carry-in is 0)
    full_adder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(c1)
    );

    // Stage 1: Second bit addition
    full_adder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(c2)
    );

    // Stage 2: Third bit addition
    full_adder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(c3)
    );

    // Stage 3: Fourth bit addition
    // The carry-out of this stage is the 5th bit (overflow/carry bit) of the sum
    full_adder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(sum[4])
    );

endmodule
