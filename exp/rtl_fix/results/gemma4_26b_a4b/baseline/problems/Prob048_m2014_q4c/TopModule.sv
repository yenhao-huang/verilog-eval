module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

    // The module implements a D flip-flop with an active-high synchronous reset.
    // Synchronous reset means the reset signal is only sampled on the rising edge of the clock.
    always @(posedge clk) begin
        if (r) begin
            // If reset is high, set output to 0
            q <= 1'b0;
        end else begin
            // Otherwise, capture the value of the input d
            q <= d;
        end
    end

endmodule
