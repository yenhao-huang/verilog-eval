module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // The counter logic is implemented within an always block 
    // triggered on the positive edge of the clock.
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset: sets the counter to 0
            q <= 4'b0000;
        end else begin
            // Increment the 4-bit counter. 
            // When q reaches 15 (4'b1111), it will naturally wrap around to 0.
            q <= q + 1'b1;
        end
    end

endmodule
