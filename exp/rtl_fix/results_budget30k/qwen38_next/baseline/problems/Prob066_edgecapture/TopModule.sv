module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out     <= 32'd0;
            prev_in <= 32'd0;
        end else begin
            // Set output bits where previous input was 1 and current input is 0.
            // Once set, keep the bit high until reset.
            out     <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule
