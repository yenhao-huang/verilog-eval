module top_module (
	input [4:1] x,
	output logic f
);

    // Combinational logic (no clk exists in the port list)
    // f = x[3]&~x[1]  |  x[4]&x[2]
    assign f = (x[3] & ~x[1]) | (x[4] & x[2]);

endmodule
