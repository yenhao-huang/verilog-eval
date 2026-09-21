module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_r;

    // Sequential logic: next state is the majority of (a, b, current state)
    always @(posedge clk) begin
        state_r <= (a & b) | (state_r & (a | b));
    end

    // Observable state output
    assign state = state_r;

    // Combinational output
    assign q = a ^ b ^ state_r;

endmodule
