module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Group the inputs into a single vector for easier indexing.
    // in[0]=a, in[1]=b, in[2]=c, in[3]=d, in[4]=e
    wire [4:0] in;
    assign in = {a, b, c, d, e};

    // The problem asks for 25 pairwise comparisons.
    // The mapping provided in the example is:
    // out[24] = a == a
    // out[23] = a == b
    // out[22] = a == c
    // ...
    // out[0]  = e == e
    //
    // This follows a pattern where the output index is determined by the 
    // row (first operand) and column (second operand).
    // Let i be the index of the first operand (0 to 4)
    // Let j be the index of the second operand (0 to 4)
    // The index in the 'out' vector is: (4 - i) * 5 + (4 - j)

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // The equality comparison (x == y) can be implemented as ~(x ^ y).
                // The prompt uses the notation ~a ^ b, which in Verilog precedence 
                // is (~a) ^ b, which is logically equivalent to ~(a ^ b).
                assign out[(4 - i) * 5 + (4 - j)] = ~(in[i] ^ in[j]);
            end
        end
    endgenerate

endmodule
