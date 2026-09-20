module top_module (
	input a,
	input b,
	input c,
	input d,
	input e,
	output [24:0] out
);

	// Left side:  ~a ~a ~a ~a ~a | ~b ~b ~b ~b ~b | ~c ~c ~c ~c ~c | ~d ~d ~d ~d ~d | ~e ~e ~e ~e ~e
	// Right side:  a  b  c  d  e |  a  b  c  d  e |  a  b  c  d  e |  a  b  c  d  e |  a  b  c  d  e
	// XOR gives equality (1 when equal): out[24]=~a^a ... out[0]=~e^e
	assign out = {{5{~a}}, {5{~b}}, {5{~c}}, {5{~d}}, {5{~e}}} ^ {5{a, b, c, d, e}};

endmodule
