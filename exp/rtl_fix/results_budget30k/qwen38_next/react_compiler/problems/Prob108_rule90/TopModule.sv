module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output [511:0] q
);

    reg [511:0] q_reg;

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            // Rule 90: next[i] = q[i-1] ^ q[i+1], boundaries are zero
            q_reg <= (q_reg << 1) ^ (q_reg >> 1);
    end

    assign q = q_reg;

endmodule
