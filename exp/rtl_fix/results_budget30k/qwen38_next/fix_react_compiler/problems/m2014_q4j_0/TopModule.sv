module top_module (
	input [3:0] x,
	input [3:0] y,
	output [4:0] sum
);
    // carry chain: c[i] is the carry out of bit i-1 (c[0] = carry in = 0)
    wire [3:0] c;

    // bit 0 : half adder (carry in = 0)
    assign sum[0] = x[0] ^ y[0];
    assign c[0]   = x[0] & y[0];

    // bit 1 : full adder
    assign sum[1] = x[1] ^ y[1] ^ c[0];
    assign c[1]   = (x[1] & y[1]) | (x[1] & c[0]) | (y[1] & c[0]);

    // bit 2 : full adder
    assign sum[2] = x[2] ^ y[2] ^ c[1];
    assign c[2]   = (x[2] & y[2]) | (x[2] & c[1]) | (y[2] & c[1]);

    // bit 3 : full adder
    assign sum[3] = x[3] ^ y[3] ^ c[2];
    assign c[3]   = (x[3] & y[3]) | (x[3] & c[2]) | (y[3] & c[2]);

    // overflow (carry out of the MSB)
    assign sum[4] = c[3];
endmodule
