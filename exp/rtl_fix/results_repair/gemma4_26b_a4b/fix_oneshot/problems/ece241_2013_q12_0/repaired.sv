module top_module (
	input clk,
	input enable,
	input S,
	input A,
	input B,
	input C,
	output reg Z
);

// The error in the original code was that 'q' was not declared.
// We declare 'q' as an 8-bit register to represent the 8 flip-flops.
reg [7:0] q;

// The shift register logic:
// S feeds the input of Q[0], and the bits shift through Q[0] to Q[7].
// This is implemented by shifting the existing bits up and placing S at the LSB (q[0]).
always @ (posedge clk) begin
	if (enable) begin
		q <= {q[6:0], S};
	end
end

// The multiplexer logic:
// Using the 3-bit input {A, B, C} to select which bit of 'q' is output to Z.
// We use '=' for combinational assignment and include a default case to prevent latches.
always @ (*) begin
	case ({A, B, C})
		3'b000: Z = q[0];
		3'b001: Z = q[1];
		3'b010: Z = q[2];
		3'b011: Z = q[3];
		3'b100: Z = q[4];
		3'b101: Z = q[5];
		3'b110: Z = q[6];
		3'b111: Z = q[7];
		default: Z = 1'b0;
	endcase
end

endmodule
