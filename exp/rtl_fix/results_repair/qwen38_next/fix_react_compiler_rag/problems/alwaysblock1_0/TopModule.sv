module top_module(
	input a, 
	input b,
	output out_assign,
	output reg out_alwaysblock
);

	// Continuous assignment (gate-level AND)
	assign out_assign = a && b;

	// Combinational always block (blocking assignment)
	always @(*) begin
		out_alwaysblock = a && b;
	end

endmodule
