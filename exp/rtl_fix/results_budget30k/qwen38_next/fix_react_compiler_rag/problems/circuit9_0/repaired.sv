module top_module (
	input clk,
	input a, 
	output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1'b1)
            q <= 3'd4;            // activity signal asserted: restart at 4
        else if (q == 3'd6)
            q <= 3'd0;            // wrap around after 6
        else
            q <= q + 3'd1;        // count up
    end

endmodule
