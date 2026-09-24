module TopModule (
    input  clk,
    input  in,
    output reg out
);

    // Optional deterministic initial value for simulation.
    // This is not a reset; remove it if an unknown power-up state is desired.
    initial out = 1'b0;

    // D = in XOR out, positive-edge triggered D flip-flop, no reset
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule
