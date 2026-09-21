module top_module (
	input [4:0] a,
	input [4:0] b,
	input [4:0] c,
	input [4:0] d,
	input [4:0] e,
	input [4:0] f,
	output [7:0] w,
	output [7:0] x,
	output [7:0] y,
	output [7:0] z
);

    // Concatenate the six 5-bit inputs plus two 1 bits (32 bits total),
    // then split the result into four 8-bit outputs.
    assign {w, x, y, z} = {a, b, c, d, e, f, 1'b1, 1'b1};

endmodule
