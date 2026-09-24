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
            // next[i] = q[i-1] ^ q[i+1], with zero boundaries
            q_reg <= {q_reg[510:0], 1'b0} ^ {1'b0, q_reg[511:1]};
    end

    assign q = q_reg;

endmodule
