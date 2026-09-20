module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // The population count is the sum of the individual bits in the input vector.
    // Since the input is 3 bits, the maximum count is 3 (2'b11), 
    // which fits perfectly in a 2-bit output.
    assign out = in[0] + in[1] + in[2];

endmodule
