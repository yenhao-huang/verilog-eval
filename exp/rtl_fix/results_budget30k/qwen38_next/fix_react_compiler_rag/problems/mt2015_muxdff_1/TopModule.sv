module top_module(
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q);

    // 1-bit multiplexer D flip-flop:
    //  L = 1 -> load r_in
    //  L = 0 -> shift in q_in
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule
