module top_module (
	input d,
	input ena,
	output logic q
);

	// D latch: level-sensitive (no clock).
	// Transparent while ena = 1, holds its value while ena = 0.
	always @(*) begin
		if (ena) begin
			q = d;
		end
	end

endmodule
