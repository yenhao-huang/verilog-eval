module TopModule (
    input clk,
    input d,
    output q
);

    // Internal registers to store the values captured at each edge
    reg q_pos;
    reg q_neg;

    // Capture the input 'd' on the rising edge of the clock
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture the input 'd' on the falling edge of the clock
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Use the current state of the clock to select the most recent value.
    // If clk is high, the last edge was a posedge, so we use q_pos.
    // If clk is low, the last edge was a negedge, so we use q_neg.
    assign q = clk ? q_pos : q_neg;

endmodule
