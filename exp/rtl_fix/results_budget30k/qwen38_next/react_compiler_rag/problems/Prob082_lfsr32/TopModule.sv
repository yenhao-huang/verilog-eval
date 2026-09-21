module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Galois LFSR: shift right; positions with a tap are XORed with q[0].
    // Taps at (1-indexed) positions 32, 22, 2, 1  ->  mask 32'h80200003
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= (q >> 1) ^ (q[0] ? 32'h80200003 : 32'h0);
    end

endmodule
