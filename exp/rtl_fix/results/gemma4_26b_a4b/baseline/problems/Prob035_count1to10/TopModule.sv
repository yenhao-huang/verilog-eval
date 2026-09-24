module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // The module implements a decade counter that counts from 1 to 10.
    // Sequential logic is triggered on the positive edge of the clock.
    // The reset is synchronous and active high, resetting the counter to 1.
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 1
            q <= 4'd1;
        end else begin
            if (q >= 4'd10) begin
                // If the counter reaches 10, wrap around to 1
                q <= 4'd1;
            end else begin
                // Otherwise, increment the counter
                // Note: If q starts at 0 (uninitialized), it will increment to 1
                q <= q + 4'd1;
            end
        end
    end

endmodule
