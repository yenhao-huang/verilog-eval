module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= q + 4'd1;   // wraps 15 -> 0 automatically, period 16
    end

endmodule
