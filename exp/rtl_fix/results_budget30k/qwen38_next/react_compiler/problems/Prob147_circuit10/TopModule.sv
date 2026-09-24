module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_r;
    assign state = state_r;

    always @(posedge clk) begin
        state_r <= (a & b) | (state_r & (a | b));
    end

    assign q = a ^ b ^ state_r;

endmodule
