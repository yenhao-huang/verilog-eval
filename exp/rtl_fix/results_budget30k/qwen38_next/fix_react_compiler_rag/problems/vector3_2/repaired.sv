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
    // The concatenated result is 6*5 + 2 = 32 bits wide,
    // so the intermediate wire must be declared as [31:0], not [7:0].
    wire [31:0] concat;
    assign concat = {a, b, c, d, e, f, 2'b11};

    // {w,x,y,z} = concat, so w holds the MSBs and z holds the LSBs
    assign w = concat[31:24];
    assign x = concat[23:16];
    assign y = concat[15:8];
    assign z = concat[7:0];
endmodule
