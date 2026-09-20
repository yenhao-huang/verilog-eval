module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Internal wire to connect the multiplexer output to the flip-flop input
    wire mux_out;

    // 2:1 Multiplexer
    // When L is asserted (1), the multiplexer selects the load value (r_in).
    // When L is de-asserted (0), the multiplexer selects the feedback/logic value (q_in).
    assign mux_out = L ? r_in : q_in;

    // Flip-flop
    // The output Q is updated on the positive edge of the clock with the value from the multiplexer.
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule
