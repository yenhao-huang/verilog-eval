module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    // Taps at bit positions 32, 22, 2, and 1 (1-based)
    // correspond to q[31], q[21], q[1], and q[0].
    localparam [31:0] TAPS = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= (q >> 1) ^ (q[0] ? TAPS : 32'h0);
        end
    end

endmodule
