module top_module (
	input [3:0] x,
	input [3:0] y,
	output [4:0] sum
);

    // carry chain: carry[0] = carry-in of bit 0, carry[4] = overflow/carry-out
    wire [4:0] c;
    assign c[0] = 1'b0;

    // Full adder 0
    assign sum[0]    = x[0] ^ y[0] ^ c[0];
    assign c[1]      = (x[0] & y[0]) | (x[0] & c[0]) | (y[0] & c[0]);

    // Full adder 1
    assign sum[1]    = x[1] ^ y[1] ^ c[1];
    assign c[2]      = (x[1] & y[1]) | (x[1] & c[1]) | (y[1] & c[1]);

    // Full adder 2
    assign sum[2]    = x[2] ^ y[2] ^ c[2];
    assign c[3]      = (x[2] & y[2]) | (x[2] & c[2]) | (y[2] & c[2]);

    // Full adder 3
    assign sum[3]    = x[3] ^ y[3] ^ c[3];
    assign c[4]      = (x[3] & y[3]) | (x[3] & c[3]) | (y[3] & c[3]);

    // Overflow (carry-out of the 4-bit adder)
    assign sum[4]    = c[4];

endmodule
