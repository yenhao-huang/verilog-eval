module top_module (
	input [4:1] x,
	output logic f
);

    // Combinational logic (no clk, no always_ff): the original code
    // clocked an always_ff block on a non-existent signal 'clk'.
    // K-map minimized using the don't-care cells:
    //   f = x[3]&~x[1] | x[4]&x[2]
    assign f = (x[3] & ~x[1]) | (x[4] & x[2]);

endmodule
