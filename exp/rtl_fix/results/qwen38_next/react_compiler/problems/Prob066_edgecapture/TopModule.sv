module TopModule (
    input             clk,
    input             reset,
    input  [31:0]     in,
    output     [31:0] out
);

    reg [31:0] in_prev;
    reg [31:0] out_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            in_prev <= in;
            // Sticky: latch a 1 whenever a bit goes 1 -> 0 between cycles
            out_reg <= out_reg | (in_prev & ~in);
        end
    end

    assign out = out_reg;

endmodule
