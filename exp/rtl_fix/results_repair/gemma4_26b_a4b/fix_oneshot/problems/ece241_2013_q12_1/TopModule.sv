module top_module (
	input clk,
	input enable,
	input S,
	input A,
	input B,
	input C,
	output Z
);

reg [7:0] q;

always @(posedge clk) begin
	if (enable) begin
		// Shift register: S feeds Q[0], and bits shift from Q[i] to Q[i+1]
		// This is a left shift where Q[0] is the LSB of the vector q[7:0]
		q <= {q[6:0], S};
	end
end

// The multiplexer selects the output based on the 3-bit address {A, B, C}
// When ABC is 000, index is 0, so Z = q[0]
// When ABC is 111, index is 7, so Z = q[7]
assign Z = q[{A, B, C}];

endmodule
