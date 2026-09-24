module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    // Taps at bit positions 32, 22, 2, and 1 (1-indexed)
    // correspond to q[31], q[21], q[1], and q[0].
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= (q >> 1) ^ ({32{q[0]}} & TAP_MASK);
        end
    end

endmodule
