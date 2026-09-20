module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    // The decade counter logic
    // Triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset: resets the counter to 0
            q <= 4'd0;
        end else if (slowena) begin
            // If slowena is high, the counter increments
            if (q >= 4'd9) begin
                // If the counter reaches 9, wrap around to 0
                q <= 4'd0;
            end else begin
                // Otherwise, increment the counter
                q <= q + 1'b1;
            end
        end
        // If slowena is low and reset is low, the counter maintains its current value (pause)
    end

endmodule
