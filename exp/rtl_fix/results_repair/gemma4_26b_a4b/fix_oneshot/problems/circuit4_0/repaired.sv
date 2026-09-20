module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output q
);

	// Based on the simulation waveform:
	// q is 0 when b=0 and c=0, regardless of a and d.
	// q is 1 when b=1 or c=1, regardless of a and d.
	// This corresponds to the logical OR operation: q = b | c.
	assign q = b | c;

endmodule
