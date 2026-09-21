module TopModule (
    input clk,
    input x,
    output z
);

    // Three flip-flop states, initially reset to zero
    reg q_xor = 1'b0;  // flip-flop fed by XOR gate
    reg q_and = 1'b0;  // flip-flop fed by AND gate
    reg q_or  = 1'b0;  // flip-flop fed by OR gate

    // Positive-edge triggered D flip-flops
    always @(posedge clk) begin
        q_xor <= x ^ q_xor;      // XOR gate input
        q_and <= x & ~q_and;     // AND gate with complemented Q
        q_or  <= x | ~q_or;      // OR gate with complemented Q
    end

    // Three-input NOR gate output
    assign z = ~(q_xor | q_and | q_or);

endmodule
