module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // One bit-slice of full_module: a 2:1 multiplexer (load vs. feedback)
    // feeding a D flip-flop.
    //   L = 1 -> load parallel input r_in
    //   L = 0 -> hold the feedback value q_in (the XOR-computed next state)
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule
