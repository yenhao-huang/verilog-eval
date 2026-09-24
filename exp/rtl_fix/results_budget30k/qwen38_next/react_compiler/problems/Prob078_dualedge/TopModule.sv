module TopModule (
    input clk,
    input d,
    output q
);
    reg p, n;

    // Captures d on the rising edge of clk
    always @(posedge clk) begin
        p <= d;
    end

    // Captures d on the falling edge of clk
    always @(negedge clk) begin
        n <= d;
    end

    // Select the value captured on the most recent edge:
    // while clk is high, output the value captured at the posedge,
    // while clk is low,  output the value captured at the negedge.
    assign q = clk ? p : n;
endmodule
