module top_module (
	input [3:0] in,
	output reg [1:0] pos
);

    // Combinational 4-bit priority encoder:
    // output the index of the first (lowest) bit that is high, 0 if in == 0
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
            pos = 2'd0;
    end

endmodule
