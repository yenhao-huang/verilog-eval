module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // The counter counts from 0 to 999, which requires 10 bits (2^10 = 1024).
    // The reset is synchronous and active-high.
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 0
            q <= 10'd0;
        end else begin
            if (q == 10'd999) begin
                // Wrap around to 0 after reaching 999
                q <= 10'd0;
            end else begin
                // Increment the counter
                q <= q + 1'b1;
            end
        end
    end

endmodule
