module TopModule (
    input clk,
    input d,
    output q
);
    reg q_pos;
    reg q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Multiplexer to select the output based on the clock edge
    assign q = clk ? q_pos : q_neg;

endmodule
