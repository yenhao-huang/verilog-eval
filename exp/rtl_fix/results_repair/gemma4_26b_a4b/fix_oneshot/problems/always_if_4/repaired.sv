module top_module (
	input a,
	input b,
	input sel_b1,
	input sel_b2,
	output out_assign,
	output reg out_always
);

	// Implementation using assign statement (combinational)
	assign out_assign = (sel_b1 && sel_b2) ? b : a;

	// Implementation using a procedural if statement (combinational)
	// We use always @(*) to ensure the logic is combinational, 
	// as a mux is a combinational circuit and no clk is provided in the module ports.
	always @(*) begin
		if (sel_b1 && sel_b2) begin
			out_always = b;
		end else begin
			out_always = a;
		end
	end

endmodule
