module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for the FSM
    // S_IDLE: Looking for the first '1'
    // S_1:    Found '1'
    // S_11:   Found '11'
    // S_110:  Found '110'
    // S_FOUND: Found '1101' (Terminal state)
    localparam S_IDLE  = 3'd0;
    localparam S_1     = 3'd1;
    localparam S_11    = 3'd2;
    localparam S_110   = 3'd3;
    localparam S_FOUND = 3'd4;

    reg [2:0] state;

    // Synchronous sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            state <= S_IDLE;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data) begin
                        state <= S_1;
                    end else begin
                        state <= S_IDLE;
                    end
                end

                S_1: begin
                    if (data) begin
                        state <= S_11;
                    end else begin
                        state <= S_IDLE;
                    end
                end

                S_11: begin
                    if (data) begin
                        // If we receive another '1', we still have '11' at the end
                        state <= S_11;
                    end else begin
                        state <= S_110;
                    end
                end

                S_110: begin
                    if (data) begin
                        // Sequence 1101 completed
                        state <= S_FOUND;
                        start_shifting <= 1'b1;
                    end else begin
                        // Sequence broken (e.g., 1100), return to IDLE
                        state <= S_IDLE;
                    end
                end

                S_FOUND: begin
                    // Stay in terminal state forever until reset
                    state <= S_FOUND;
                    start_shifting <= 1'b1;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
