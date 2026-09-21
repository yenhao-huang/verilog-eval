module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    // Priority encoder: report the index of the lowest-order bit that is high.
    // If no bit is high, output 0.
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
