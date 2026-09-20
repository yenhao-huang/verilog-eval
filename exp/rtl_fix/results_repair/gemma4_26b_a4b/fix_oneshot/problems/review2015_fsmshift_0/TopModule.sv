module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] state;

    // Synchronous reset and state transition logic
    always @(posedge clk) begin
        if (reset) begin
            // When reset is asserted, go to state B0
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= 3'b001; // B0 -> B1
                3'b001: state <= 3'b010; // B1 -> B2
                3'b010: state <= 3'b011; // B2 -> B3
                3'b011: state <= 3'b100; // B3 -> Done
                default: state <= 3'b100; // Stay in Done
            endcase
        end
    end

    // shift_ena is asserted for states B0, B1, B2, and B3
    assign shift_ena = (state == 3'b000) || (state == 3'b001) || (state == 3'b010) || (state == 3'b011);

endmodule
