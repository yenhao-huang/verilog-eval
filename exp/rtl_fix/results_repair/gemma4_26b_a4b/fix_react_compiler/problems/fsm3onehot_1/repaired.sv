module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

always @(*) begin
    // Initialize next_state to 0 to avoid latches
    next_state = 4'b0000;
    
    case (state)
        4'b0001: begin // State A
            if (in) next_state = 4'b0010; // B
            else    next_state = 4'b0001; // A
        end
        4'b0010: begin // State B
            if (in) next_state = 4'b0010; // B
            else    next_state = 4'b0100; // C
        end
        4'b0100: begin // State C
            if (in) next_state = 4'b1000; // D
            else    next_state = 4'b0001; // A
        end
        4'b1000: begin // State D
            if (in) next_state = 4'b0010; // B
            else    next_state = 4'b0100; // C
        end
        default: next_state = 4'b0000;
    endcase
end

assign out = state[3];

endmodule
