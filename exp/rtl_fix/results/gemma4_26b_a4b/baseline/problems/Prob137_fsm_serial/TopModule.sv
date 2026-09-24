module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    // State encoding for the FSM
    localparam IDLE  = 2'b00; // Waiting for start bit (0)
    localparam DATA  = 2'b01; // Collecting 8 data bits
    localparam STOP  = 2'b10; // Verifying stop bit (1)
    localparam ERROR = 2'b11; // Waiting for stop bit (1) after an error

    // Internal registers
    reg [1:0] state;
    reg [2:0] bit_cnt;    // Counter to track the 8 data bits
    reg       done_reg;   // Internal register for the done signal

    // FSM logic
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            state   <= IDLE;
            bit_cnt <= 3'd0;
            done_reg <= 1'b0;
        end else begin
            // Default: done_reg is 0 unless a valid byte is completed in the STOP state
            done_reg <= 1'b0;

            case (state)
                IDLE: begin
                    // Transition to DATA state when start bit (0) is detected
                    if (in == 1'b0) begin
                        state   <= DATA;
                        bit_cnt <= 3'd0;
                    end
                end

                DATA: begin
                    // Count 8 bits (0 through 7)
                    if (bit_cnt == 3'd7) begin
                        state <= STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 3'd1;
                    end
                end

                STOP: begin
                    // Check if the stop bit is 1
                    if (in == 1'b1) begin
                        done_reg <= 1'b1; // Pulse done for one cycle
                        state    <= IDLE;
                    end else begin
                        // If stop bit is 0, transition to error handling
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    // Wait until the line returns to 1 (stop bit/idle) before returning to IDLE
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignment
    assign done = done_reg;

endmodule
