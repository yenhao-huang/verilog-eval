module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    parameter S_SEARCH         = 2'b00;
    parameter S_SHIFT          = 2'b01;
    parameter S_WAIT_COUNTING  = 2'b10;
    parameter S_WAIT_ACK       = 2'b11;

    reg [1:0] state;
    reg [3:0] data_reg; // Shift register to detect the 1101 pattern
    reg [1:0] shift_cnt; // Counter to track the 4 cycles of shift_ena

    // Finite State Machine logic
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            state <= S_SEARCH;
            data_reg <= 4'b0000;
            shift_cnt <= 2'b00;
        end else begin
            case (state)
                S_SEARCH: begin
                    // Continuously shift in data to look for the pattern 1101
                    data_reg <= {data_reg[2:0], data};
                    
                    // Check if the most recent 4 bits form the pattern 1101
                    // We check the combination of the current data_reg and the incoming data bit
                    if ({data_reg[2:0], data} == 4'b1101) begin
                        state <= S_SHIFT;
                        shift_cnt <= 2'b00;
                    end
                end

                S_SHIFT: begin
                    // Assert shift_ena for exactly 4 clock cycles
                    if (shift_cnt == 2'b11) begin
                        state <= S_WAIT_COUNTING;
                        shift_cnt <= 2'b00;
                    end else begin
                        shift_cnt <= shift_cnt + 1'b1;
                    end
                end

                S_WAIT_COUNTING: begin
                    // Wait for the external counter to signal it is finished
                    if (done_counting) begin
                        state <= S_WAIT_ACK;
                    end
                end

                S_WAIT_ACK: begin
                    // Wait for the user to acknowledge the timer completion
                    if (ack) begin
                        state <= S_SEARCH;
                    end
                end

                default: begin
                    state <= S_SEARCH;
                end
            endcase
        end
    end

    // Output assignments based on the current state
    // shift_ena is high only during the S_SHIFT state (4 cycles)
    assign shift_ena = (state == S_SHIFT);
    
    // counting is high while waiting for the counter to finish
    assign counting  = (state == S_WAIT_COUNTING);
    
    // done is high while waiting for the user acknowledgment
    assign done      = (state == S_WAIT_ACK);

endmodule
