module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output q
);

// q is high whenever b OR c is high (a and d are don't-cares)
assign q = b | c;

endmodule
