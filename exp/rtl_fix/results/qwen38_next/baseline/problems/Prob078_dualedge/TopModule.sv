module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos;
    reg q_neg;

    // Capture d on the rising edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture d on the falling edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Select the most recently captured value based on clock phase
    assign q = clk ? q_pos : q_neg;

endmodule
