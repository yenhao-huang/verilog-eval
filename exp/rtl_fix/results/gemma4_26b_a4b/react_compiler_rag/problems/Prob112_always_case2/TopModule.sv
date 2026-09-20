module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

/*
 * A priority encoder is a combinational circuit that, when given an input bit vector, 
 * outputs the position of the first 1 bit in the vector.
 * For example, a 8-bit priority encoder given the input 8'b10010000 would output 3'd4, 
 * because bit[4] is the first bit that is high (scanning from LSB to MSB).
 * 
 * For this 4-bit priority encoder:
 * - If in[0] is 1, pos = 0.
 * - If in[0] is 0 and in[1] is 1, pos = 1.
 * - If in[0] is 0, in[1] is 0, and in[2] is 1, pos = 2.
 * - If in[0], in[1], in[2] are 0, and in[3] is 1, pos = 3.
 * - If all input bits are 0, pos = 0.
 */

always @(*) begin
    if (in[0])
        pos = 2'd0;
    else if (in[1])
        pos = 2'd1;
    else if (in[2])
        pos = 2'd2;
    else if (in[3])
        pos = 2'd3;
    else
        pos = 2'd0;
end

endmodule
