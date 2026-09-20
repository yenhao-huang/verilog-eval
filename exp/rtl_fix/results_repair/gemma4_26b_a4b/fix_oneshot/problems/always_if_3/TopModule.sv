module top_module (
	input a,
	input b,
	input sel_b1,
	input sel_b2,
	output out_assign,
	output reg out_always
);

	// Using assign statements
	// This implements a combinational 2-to-1 mux.
	assign out_assign = (sel_b1 & sel_b2) ? b : a;

	// Using a procedural if statement
	// To "do the same" as the assign statement, this must also be combinational.
	// We use always @(*) for combinational logic and blocking assignments (=).
	always @(*) begin
		if (sel_b1 & sel_b2) begin
			out_always = b;
		end else begin
			out_always = a;
		end
	end

endmodule
