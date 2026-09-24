module TopModule (
    input clk,
    input reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (reset) begin
            out     <= 32'd0;
            in_prev <= 32'd0;
        end else begin
            out     <= out | (in_prev & ~in);
            in_prev <= in;
        end
    end

endmodule
