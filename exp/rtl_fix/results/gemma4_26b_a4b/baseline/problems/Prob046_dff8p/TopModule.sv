module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // The module implements 8 D flip-flops triggered on the negative edge of the clock.
    // The reset is synchronous (checked only on the clock edge) and active high.
    // Per requirements, the reset value is 8'h34.
    always @(negedge clk) begin
        if (reset) begin
            q <= 8'h34;
        end else begin
            q <= d;
        end
    end

endmodule
