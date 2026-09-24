module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);

    // Taps at 1-indexed positions 32, 22, 2, 1  ->  bits 31, 21, 1, 0
    localparam [31:0] TAP_MASK = 32'h8020_0003;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h0000_0001;
        else
            q <= (q >> 1) ^ ({32{q[0]}} & TAP_MASK);
    end

endmodule
