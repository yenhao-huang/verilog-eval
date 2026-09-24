module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    // Galois LFSR: shifts right; tapped positions are XORed with q[0].
    // Taps at 1-indexed positions 32, 22, 2, 1 -> bit indices 31, 21, 1, 0
    // Feedback mask = (1<<31) | (1<<21) | (1<<1) | (1<<0) = 32'h8020_0003
    always @(posedge clk) begin
        if (reset)
            q <= 32'h0000_0001;
        else
            q <= (q >> 1) ^ (q[0] ? 32'h8020_0003 : 32'h0000_0000);
    end

endmodule
