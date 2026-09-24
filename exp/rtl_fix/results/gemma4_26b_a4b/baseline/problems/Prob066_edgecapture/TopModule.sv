module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Internal register to store the state of the input from the previous clock cycle
    // to allow for edge detection.
    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset: clear the output and the previous state register
            out <= 32'b0;
            in_prev <= 32'b0;
        end else begin
            // Falling edge detection logic:
            // A falling edge occurs when the previous bit was 1 (in_prev) 
            // and the current bit is 0 (~in).
            // We use the bitwise AND to find these specific bits.
            // The output 'out' is updated using a bitwise OR to "capture" 
            // the event, ensuring once a bit becomes 1, it stays 1.
            out <= out | (in_prev & ~in);
            
            // Update the previous state register for the next clock cycle
            in_prev <= in;
        end
    end

endmodule
