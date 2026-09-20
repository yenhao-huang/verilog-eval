module top_module (
	input [7:0] in,
	output [7:0] out
);

    // Continuous assignment: out must stay a wire, so no always block / no clk.
    // Reverse the bit ordering of the 8-bit input combinationally.
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule
