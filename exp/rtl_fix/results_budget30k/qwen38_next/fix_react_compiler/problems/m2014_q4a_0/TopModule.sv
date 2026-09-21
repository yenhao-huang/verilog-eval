module top_module (
	input d,
	input ena,
	output logic q
);

	// Level-sensitive D latch: q follows d while ena is high,
	// and holds its value when ena is low.
	always_latch begin
		if (ena) begin
			q = d;
		end
	end

endmodule
