module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State definitions
    parameter IDLE = 2'b00;
    parameter S1   = 2'b01;
    parameter S2   = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            IDLE: begin
                if (x)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S2: begin
                if (x)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Mealy output logic: z is 1 when in S2 and x is 1
    assign z = (state == S2 && x == 1'b1);

endmodule
