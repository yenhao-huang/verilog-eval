module top_module (
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out
);

	// Combinational 2-to-1 mux: no clock exists in this design
	always @(*) begin
		out = (~sel & a) | (sel & b);
	end

endmodule
