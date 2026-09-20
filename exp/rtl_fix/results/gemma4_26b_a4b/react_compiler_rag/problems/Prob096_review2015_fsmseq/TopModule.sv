```verilog
module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states for the FSM
    parameter IDLE = 3'd0, 
              S1   = 3'd1, // Found '1'
              S2   = 3'd2, // Found '11'
              S3   = 3'd3, // Found '110'
              S4   = 3'd4; // Found '1101' (Sequence complete)

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: reset state and output
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                end

                S1: begin
                    if (data) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end

                S2: begin
                    if (data) begin
                        // If we have '11' and get another '1', we still have '11' as the last two bits
                        state <= S2;
                    end else begin
                        state <= S3;
                    end
                end

                S3: begin
                    if (data) begin
                        // Sequence '1101' is found
                        state <= S4;
                        start_shifting <= 1'b1;
                    end else begin
                        // If we have '110' and get '0',
