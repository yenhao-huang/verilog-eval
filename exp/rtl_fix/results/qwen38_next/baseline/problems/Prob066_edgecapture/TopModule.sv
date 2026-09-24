module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] in_prev = 32'd0;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'd0;
        end else begin
            // Sticky set: set bits where previous input was 1 and current input is 0
            out <= out | (in_prev & ~in);
        end

        // Track previous sampled input value
        in_prev <= in;
    end

endmodule
