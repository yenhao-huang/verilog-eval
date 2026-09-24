module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    // Galois LFSR: shifts right. Taps at bit positions 32, 22, 2, 1
    // (1-indexed) => bit indices 31, 21, 1, 0.
    // Mask = (1<<31) | (1<<21) | (1<<1) | (1<<0) = 32'h80200003
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h00000001;
        end else begin
            q <= (q >> 1) ^ (q[0] ? 32'h80200003 : 32'h00000000);
        end
    end

endmodule
