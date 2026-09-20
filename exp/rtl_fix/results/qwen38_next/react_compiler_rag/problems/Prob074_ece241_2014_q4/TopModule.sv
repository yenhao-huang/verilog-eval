module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    always @(posedge clk) begin
        q_xor <= x ^ q_xor;   // XOR gate fed by x and its own FF output
        q_and <= x & ~q_and;  // AND gate fed by x and complemented FF output
        q_or  <= x | ~q_or;   // OR gate fed by x and complemented FF output
    end

    // Three-input NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule
