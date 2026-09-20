module top_module (
	input [2:0] a, 
	output reg [15:0] q
);

always @(*) begin
	case (a)
		3'b000:  q = 16'h1232;   // 16'd4658
		3'b001:  q = 16'haee0;   // 16'd44768
		3'b010:  q = 16'h27d4;   // 16'd10196
		3'b011:  q = 16'h5a0e;   // 16'd23054
		3'b100:  q = 16'h2066;   // 16'd8294
		3'b101:  q = 16'h64ce;   // 16'd25806
		3'b110:  q = 16'hc526;   // 16'd50470
		3'b111:  q = 16'h2f19;   // 16'd12057
		default: q = 16'hxxxx;
	endcase
end

endmodule
