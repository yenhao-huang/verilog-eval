module top_module (
	input a, 
	input b,
	input c,
	input d,
	output reg out
);

	// Combinational logic (no clock exists in this design):
	// use always @(*) with blocking assignments.
	// K-map simplification: out = a | (~b & c)
	always @(*) begin
		out = a | (~b & c);
	end

endmodule
