module top_module (
	input [7:0] in,
	output parity
);

	// The parity bit is the XOR reduction of all bits in the input byte.
	// For even parity, the parity bit is 1 if the number of set bits is odd,
	// and 0 if the number of set bits is even, ensuring the total number 
	// of 1s (data + parity) is even.
	assign parity = ^in;

endmodule
