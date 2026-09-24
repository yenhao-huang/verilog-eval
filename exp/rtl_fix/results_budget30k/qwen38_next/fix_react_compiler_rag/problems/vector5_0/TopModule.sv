module top_module (
	input a,
	input b,
	input c,
	input d,
	input e,
	output [24:0] out
);

	// {~a x5, ~b x5, ~c x5, ~d x5, ~e x5} XOR {a,b,c,d,e} repeated 5 times
	assign out = { {5{~a}}, {5{~b}}, {5{~c}}, {5{~d}}, {5{~e}} } ^ {5{a,b,c,d,e}};

endmodule
