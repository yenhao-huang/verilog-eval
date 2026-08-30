module TopModule (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev;

    always_ff @(posedge clk) begin
        if (reset) begin
            out  <= 32'd0;
            prev <= 32'd0;
        end else begin
            prev <= in;
            out  <= out | (prev & ~in);
        end
    end

endmodule
