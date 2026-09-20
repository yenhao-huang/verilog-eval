module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

    // both: in[i] and in[i+1] are 1  (i = 98..0)
    assign out_both = in[98:0] & in[99:1];

    // any: in[i] or in[i-1] is 1     (i = 99..1)
    assign out_any = in[99:1] | in[98:0];

    // different: in[i] differs from left neighbour in[i+1],
    // wrapping so that in[99]'s left neighbour is in[0]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule
