module top_module (
	input d,
	input ena,
	output logic q
);

	// D latch: level-sensitive, no clock.
	// All inputs must be in the sensitivity list so the latch is
	// re-evaluated whenever d or ena changes.
	always @(d or ena) begin
		if (ena) begin
			q = d;      // transparent while ena is high
		end
		// when ena == 0, q holds its previous value (latched)
	end

endmodule
