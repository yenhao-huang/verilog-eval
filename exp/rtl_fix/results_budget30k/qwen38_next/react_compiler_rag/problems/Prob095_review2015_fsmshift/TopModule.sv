module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // States 0..3 are the four shift-enable cycles, state 4 is "done"
    reg [2:0] state;

    // Start in the done state so shift_ena is 0 until reset is applied
    initial state = 3'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;              // active-high synchronous reset
        end else begin
            case (state)
                3'd0:    state <= 3'd1;
                3'd1:    state <= 3'd2;
                3'd2:    state <= 3'd3;
                3'd3:    state <= 3'd4;
                default: state <= 3'd4;  // stay in done forever
            endcase
        end
    end

    // assert shift_ena for exactly 4 cycles after reset
    assign shift_ena = (state == 3'd0) ||
                       (state == 3'd1) ||
                       (state == 3'd2) ||
                       (state == 3'd3);

endmodule
