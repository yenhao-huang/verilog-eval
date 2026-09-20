module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // The module implements 8 D flip-flops with a synchronous active-high reset.
    // All operations are triggered on the positive edge of the clock.
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: sets the output to zero
            q <= 8'b0;
        end else begin
            // Data transfer: captures the input d into output q
            q <= d;
        end
    end

endmodule
