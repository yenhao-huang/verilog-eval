module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    /*
     * To implement a serial 2's complementer, we follow the rule:
     * 1. Scan from LSB to MSB.
     * 2. Keep all bits the same until the first '1' is encountered.
     * 3. After the first '1' is encountered, flip all subsequent bits.
     *
     * Since this is a Moore state machine, the output (z) must depend 
     * only on the current state.
     *
     * State Definitions:
     * S_ZERO:   We are in the initial phase (haven't seen a '1' yet). Output z = 0.
     * S_ONE:    The current bit is the first '1' encountered. Output z = 1.
     * S_FLIP_1: We are in the flipping phase and the current bit's complement is 1. Output z = 1.
     * S_FLIP_0: We are in the flipping phase and the current bit's complement is 0. Output z = 0.
     */

    localparam S_ZERO   = 2'b00;
    localparam S_ONE    = 2'b01;
    localparam S_FLIP_1 = 2'b10;
    localparam S_FLIP_0 = 2'b11;

    reg [1:0] state;

    // Sequential logic for state transitions
    // The reset is asynchronous and positive edge triggered.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_ZERO;
        end else begin
            case (state)
                S_ZERO: begin
                    if (x == 1'b1)
                        state <= S_ONE;
                    else
                        state <= S_ZERO;
                end
                
                S_ONE: begin
                    // After the first '1', we enter the flipping phase.
                    // If the next bit is 0, its complement is 1.
                    // If the next bit is 1, its complement is 0.
                    if (x == 1'b0)
                        state <= S_FLIP_1;
                    else
                        state <= S_FLIP_0;
                end
                
                S_FLIP_1: begin
                    // In flipping mode:
                    // If x is 0, complement is 1 (stay in S_FLIP_1).
                    // If x is 1, complement is 0 (move to S_FLIP_0).
                    if (x == 1'b0)
                        state <= S_FLIP_1;
                    else
                        state <= S_FLIP_0;
                end
                
                S_FLIP_0: begin
                    // In flipping mode:
                    // If x is 0, complement is 1 (move to S_FLIP_1).
                    // If x is 1, complement is 0 (stay in S_FLIP_0).
                    if (x == 1'b0)
                        state <= S_FLIP_1;
                    else
                        state <= S_FLIP_0;
                end
                
                default: state <= S_ZERO;
            endcase
        end
    end

    // Combinational logic for Moore output
    // The output z is determined solely by the current state.
    assign z = (state == S_ONE || state == S_FLIP_1);

endmodule
