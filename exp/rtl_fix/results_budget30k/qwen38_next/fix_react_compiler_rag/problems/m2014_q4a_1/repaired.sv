module top_module (
	input d,
	input ena,
	output logic q
);

  // D latch: level sensitive -- q follows d while ena is high,
  // and holds its previous value when ena is low.
  always_latch begin
    if (ena)
      q = d;
  end

endmodule
