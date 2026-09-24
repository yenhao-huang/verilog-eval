module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            2'b00: begin  // A
                if (in) next_state = 2'b01;   // B
                else    next_state = 2'b00;   // A
            end
            2'b01: begin  // B
                if (in) next_state = 2'b01;   // B
                else    next_state = 2'b10;   // C
            end
            2'b10: begin  // C
                if (in) next_state = 2'b11;   // D
                else    next_state = 2'b00;   // A
            end
            2'b11: begin  // D
                if (in) next_state = 2'b01;   // B
                else    next_state = 2'b10;   // C
            end
            default: next_state = 2'b00;
        endcase
    end

    // Moore output logic: driven with a continuous assignment because
    // 'out' is declared as a wire (output out), not output reg out.
    assign out = (state == 2'b11);

endmodule
