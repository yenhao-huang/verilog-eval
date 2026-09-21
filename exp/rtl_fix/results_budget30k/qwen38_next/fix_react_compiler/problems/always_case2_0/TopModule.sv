module top_module (
	input [3:0] in,
	output reg [1:0] pos
);

    // Combinational priority encoder: no clock, since this is pure combinational logic.
    always @(*) begin
        if (in[0])
            pos = 2'd0;
        else if (in[1])
            pos = 2'd1;
        else if (in[2])
            pos = 2'd2;
        else if (in[3])
            pos = 2'd3;
        else
            pos = 2'd0;   // no bits high -> output 0
    end

endmodule
