module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    // State encoding: S0..S3 = the 4 shift-enable cycles, S4 = idle forever
    localparam [2:0] S0 = 3'd0,
                     S1 = 3'd1,
                     S2 = 3'd2,
                     S3 = 3'd3,
                     S4 = 3'd4;

    reg [2:0] state;

    // Power-up in the idle state (no enable until a reset occurs)
    initial state = S4;

    // Synchronous, active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end
        else begin
            case (state)
                S0:      state <= S1;
                S1:      state <= S2;
                S2:      state <= S3;
                S3:      state <= S4;
                default: state <= S4;   // stay here until the next reset
            endcase
        end
    end

    // Moore output: asserted for exactly 4 cycles after reset, then 0 forever
    assign shift_ena = (state != S4);

endmodule
