module top_module (
	input d,
	input ena,
	output logic q
);

	// D latch: transparent when ena = 1, holds state when ena = 0
	always_latch begin
		if (ena) begin
			q = d;
		end
	end

endmodule
