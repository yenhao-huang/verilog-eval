module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg pff = 1'b0;  // captures d on rising edge
    reg nff = 1'b0;  // captures d on falling edge

    always @(posedge clk) begin
        pff <= d;
    end

    always @(negedge clk) begin
        nff <= d;
    end

    // Select the value captured on the most recent clock edge.
    assign q = clk ? pff : nff;

endmodule
