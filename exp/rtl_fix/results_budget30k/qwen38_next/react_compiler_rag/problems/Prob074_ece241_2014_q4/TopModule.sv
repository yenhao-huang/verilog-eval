module TopModule (
    input  clk,
    input  x,
    output z
);

    // State bits: outputs of the three D flip-flops (reset to 0)
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Gate outputs drive the D inputs of the corresponding flip-flops
    wire d_xor = x ^  q_xor;   // XOR  with its own flip-flop output
    wire d_and = x & ~q_and;   // AND  with its own complemented output
    wire d_or  = x | ~q_or;    // OR   with its own complemented output

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Three-input NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
