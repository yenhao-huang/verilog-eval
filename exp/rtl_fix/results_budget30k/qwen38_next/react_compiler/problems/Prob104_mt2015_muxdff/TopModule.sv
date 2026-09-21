module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // 2:1 multiplexer followed by a D flip-flop.
    // L = 1: load from r_in
    // L = 0: hold the feedback value q_in (computed by the parent module)
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule
