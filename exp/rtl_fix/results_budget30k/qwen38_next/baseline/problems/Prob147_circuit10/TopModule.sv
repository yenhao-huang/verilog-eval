module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg state_r;

    // Next state is the majority of {state_r, a, b}
    always @(posedge clk) begin
        state_r <= (state_r & a) | (state_r & b) | (a & b);
    end

    assign state = state_r;

    // Output is the XOR of the state and the two inputs
    assign q = state_r ^ a ^ b;

endmodule
