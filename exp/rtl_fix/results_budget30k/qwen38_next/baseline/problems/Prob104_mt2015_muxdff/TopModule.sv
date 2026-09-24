module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire d;

    // 2:1 multiplexer:
    // L = 1 -> load r_in
    // L = 0 -> use q_in feedback value
    assign d = L ? r_in : q_in;

    // Flip-flop
    always @(posedge clk) begin
        Q <= d;
    end

endmodule
