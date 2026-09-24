module top_module (
	input [2:0] a, 
	output reg [15:0] q
);

	// Combinational lookup table (no clock in this design)
	always @(*) begin
		case (a)
			3'b000:  q = 16'h1232;   // 4658
			3'b001:  q = 16'hAEE0;   // 44768
			3'b010:  q = 16'h27D4;   // 10196
			3'b011:  q = 16'h5A0E;   // 23054
			3'b100:  q = 16'h2066;   // 8294
			3'b101:  q = 16'h64CE;   // 25806
			3'b110:  q = 16'hC526;   // 50470
			3'b111:  q = 16'h2F19;   // 12057
			default: q = 16'h0000;
		endcase
	end

endmodule
