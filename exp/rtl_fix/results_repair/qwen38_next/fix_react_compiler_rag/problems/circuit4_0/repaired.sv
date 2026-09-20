module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output q
);

	// From the waveform, q = 1 whenever b = 1 or c = 1,
	// regardless of the values of a and d.
	assign q = b | c;

endmodule
