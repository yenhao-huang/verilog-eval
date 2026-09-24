module top_module (
	input a, 
	input b,
	input c,
	input d,
	output out
);

    // K-map grouping:
    //   ~b & ~c  -> minterms 0,1,8,9
    //   ~a & ~d  -> minterms 0,2,4,6
    //   a & c & d -> minterms 11,15
    //   b & c & d -> minterms 7,15
    assign out = (~c & ~b) | (~d & ~a) | (a & c & d) | (b & c & d);

endmodule
