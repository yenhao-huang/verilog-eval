module TopModule (
    input  clk,
    input  d,
    output q
);

    reg pos_q;
    reg neg_q;

    // Capture on rising edge
    always @(posedge clk) begin
        pos_q <= d;
    end

    // Capture on falling edge
    always @(negedge clk) begin
        neg_q <= d;
    end

    // Select the most recently captured value:
    // while clk is high, the last event was a posedge -> use pos_q
    // while clk is low,  the last event was a negedge -> use neg_q
    assign q = clk ? pos_q : neg_q;

endmodule
