module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    // The module implements the combinational logic for a Moore state machine.
    // State encoding: A=2'b00, B=2'b01, C=2'b10, D=2'b11.
    // Moore machine: Output depends only on the current state.

    always @(*) begin
        // Default assignments to prevent latches
        next_state = 2'b00;
        out = 1'b0;

        case (state)
            2'b00: begin // State A
                if (in == 1'b1)
                    next_state = 2'b01; // Next state B
                else
                    next_state = 2'b00; // Next state A
                out = 1'b0;
            end

            2'b01: begin // State B
                if (in == 1'b1)
                    next_state = 2'b01; // Next state B
                else
                    next_state = 2'b10; // Next state C
                out = 1'b0;
            end

            2'b10: begin // State C
                if (in == 1'b1)
                    next_state = 2'b11; // Next state D
                else
                    next_state = 2'b00; // Next state A
                out = 1'b0;
            end

            2'b11: begin // State D
                if (in == 1'b1)
                    next_state = 2'b01; // Next state B
                else
                    next_state = 2'b10; // Next state C
                out = 1'b1;
            end

            default: begin
                next_state = 2'b00;
                out = 1'b0;
            end
        endcase
    end

endmodule
