module TopModule (
    input        clk,
    input        reset,
    input  [31:0] in,
    output [31:0] out
);

    reg [31:0] out_reg;
    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 32'd0;
            in_prev <= 32'd0;
        end else begin
            // Sticky capture: set bit when previous cycle was 1 and this cycle is 0
            out_reg <= out_reg | (in_prev & ~in);
            in_prev <= in;
        end
    end

    assign out = out_reg;

endmodule
