module TopModule (
    input clk,
    input d,
    output q
);
    // We use two separate registers to capture the value of 'd' 
    // on the positive and negative edges of the clock.
    reg q_pos;
    reg q_neg;

    // Capture 'd' on the positive edge of the clock.
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture 'd' on the negative edge of the clock.
    always @(negedge clk) begin
        q_neg <= d;
    end

    // The output 'q' is selected based on the current state of the clock.
    // When the clock is high, 'q' follows the value captured at the last positive edge.
    // When the clock is low, 'q' follows the value captured at the last negative edge.
    // This effectively creates a dual-edge triggered flip-flop.
    assign q = clk ? q_pos : q_neg;

endmodule
