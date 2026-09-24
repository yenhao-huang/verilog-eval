module top_module (
	input [4:1] x,
	output logic f
);

  // K-map simplification (don't-cares chosen to form the two groups):
  //   group 1: x[3] = 1, x[1] = 0
  //   group 2: x[4] = 1, x[2] = 1
  assign f = (x[3] & ~x[1]) | (x[4] & x[2]);

endmodule
