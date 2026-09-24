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
    // 30 input bits + 2 bits of '1' = 32 bits total
    wire [31:0] concat;                 // was wrongly declared as [7:0]

    assign concat = {a, b, c, d, e, f, 2'b11};

    assign w = concat[31:24];           // {a,     b[4:2]}
    assign x = concat[23:16];           // {b[1:0], c, d[4:3]}
    assign y = concat[15:8];            // {d[2:0], e, f[4]}
    assign z = concat[7:0];             // {f[3:0], 2'b11}
endmodule
