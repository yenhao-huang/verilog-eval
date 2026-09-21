module top_module (
	input clk,
	input enable,
	input S,
	input A,
	input B,
	input C,
	output reg Z
);

	// 8-bit shift register built from 8 D flip-flops (MSB shifted in first)
	reg [7:0] q;   // <-- this declaration was missing in the erroneous code

	always @(posedge clk) begin
		if (enable)
			q <= {q[6:0], S};
	end

	// 8:1 multiplexer: ABC = 000 -> Q[0], 001 -> Q[1], ... 111 -> Q[7]
	always @(*) begin
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
