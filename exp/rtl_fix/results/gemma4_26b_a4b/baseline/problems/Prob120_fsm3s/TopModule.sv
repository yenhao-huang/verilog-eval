module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_A = 2'b00;
    parameter STATE_B = 2'b01;
    parameter STATE_C = 2'b10;
    parameter STATE_D = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // Sequential logic for state transitions
    // Synchronous active high reset to State A
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state calculation
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            STATE_B: begin
                if (in == 1'b0)
                    next_state = STATE_C;
                else
                    next_state = STATE_B;
            end
            STATE_C: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_D;
            end
            STATE_D: begin
                if (in == 1'b0)
                    next_state = STATE_C;
                else
                    next_state = STATE_B;
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Combinational logic for Moore output
    // In a Moore machine, the output depends only on the current state
    assign out = (current_state == STATE_D) ? 1'b1 : 1'b0;

endmodule
