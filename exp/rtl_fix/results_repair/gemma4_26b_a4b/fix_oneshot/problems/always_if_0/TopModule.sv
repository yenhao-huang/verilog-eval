module top_module (
	input a,
	input b,
	input sel_b1,
	input sel_b2,
	output out_assign,
	output reg out_always
);

	// Implementation using assign statement
	assign out_assign = (sel_b1 && sel_b2) ? b : a;
	
	// Implementation using a procedural if statement
	// Note: Since no clk is provided in the module ports, 
	// the procedural block must be combinational to match the assign statement.
	always @(*) begin
		if (sel_b1 && sel_b2) begin
			out_always = b;
		end else begin
			out_always = a;
		end
	end
	
endmodule
