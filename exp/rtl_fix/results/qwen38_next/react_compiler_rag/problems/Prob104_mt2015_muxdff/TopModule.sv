module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // 2:1 multiplexer followed by a D flip-flop:
    //   L = 1 -> load from r_in
    //   L = 0 -> hold/feedback value supplied on q_in
    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in;
        end
    end

endmodule
