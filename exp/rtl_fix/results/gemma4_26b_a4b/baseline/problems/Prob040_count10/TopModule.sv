module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // The decade counter logic
    // Triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset: resets the counter to 0
            q <= 4'd0;
        end else begin
            // If the counter reaches 9, wrap around to 0
            if (q >= 4'd9) begin
                q <= 4'd0;
            end else begin
                // Otherwise, increment the counter
                q <= q + 4'd1;
            end
        end
    end

endmodule
