module TopModule (
    input  clk,
    input  L,
    input  q_in,   // feedback value (shift/XOR result) used when L == 0
    input  r_in,   // parallel load value used when L == 1
    output reg Q
);

    // 2:1 multiplexer followed by a D flip-flop
    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule
