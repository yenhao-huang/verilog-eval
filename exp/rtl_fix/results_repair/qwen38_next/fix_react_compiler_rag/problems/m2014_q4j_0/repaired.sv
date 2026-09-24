module top_module (
	input [3:0] x,
	input [3:0] y,
	output [4:0] sum
);
	// Carry chain: c[i] is the carry out of bit i
	wire [3:0] c;

	// Bit 0 : half adder (carry-in = 0)
	assign sum[0] = x[0] ^ y[0];
	assign c[0]   = x[0] & y[0];

	// Bit 1 : full adder
	assign sum[1] = x[1] ^ y[1] ^ c[0];
	assign c[1]   = (x[1] & y[1]) | (c[0] & (x[1] ^ y[1]));

	// Bit 2 : full adder
	assign sum[2] = x[2] ^ y[2] ^ c[1];
	assign c[2]   = (x[2] & y[2]) | (c[1] & (x[2] ^ y[2]));

	// Bit 3 : full adder
	assign sum[3] = x[3] ^ y[3] ^ c[2];
	assign c[3]   = (x[3] & y[3]) | (c[2] & (x[3] ^ y[3]));

	// Overflow (carry out of the MSB)
	assign sum[4] = c[3];
endmodule
