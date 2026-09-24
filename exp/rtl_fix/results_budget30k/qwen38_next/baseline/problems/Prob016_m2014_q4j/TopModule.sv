module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire [4:0] carry;

    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adders
            full_adder fa (
                .a   (x[i]),
                .b   (y[i]),
                .cin (carry[i]),
                .sum (sum[i]),
                .cout(carry[i + 1])
            );
        end
    endgenerate

    assign sum[4] = carry[4];

endmodule

module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    wire a_xor_b;

    assign a_xor_b = a ^ b;
    assign sum     = a_xor_b ^ cin;
    assign cout    = (a & b) | (cin & a_xor_b);

endmodule
