module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

// The problem asks for the combinational logic portion of a Moore state machine.
// This includes the next_state logic and the output logic.

always @(*) begin
	case (state)
		// State A (2'b00): Next state in=0 is A (2'b00), in=1 is B (2'b01). Output is 0.
		2'b00: next_state = in ? 2'b01 : 2'b00;
		
		// State B (2'b01): Next state in=0 is C (2'b10), in=1 is B (2'b01). Output is 0.
		2'b01: next_state = in ? 2'b01 : 2'b10;
		
		// State C (2'b10): Next state in=0 is A (2'b00), in=1 is D (2'b11). Output is 0.
		2'b10: next_state = in ? 2'b11 : 2'b00;
		
		// State D (2'b11): Next state in=0 is C (2'b10), in=1 is B (2'b01). Output is 1.
		2'b11: next_state = in ? 2'b01 : 2'b10;
		
		// Default case to prevent latches
		default: next_state = 2'b00;
	endcase
end

// Moore machine output depends only on the current state.
// Output is 1 only when the current state is D (2'b11).
assign out = (state == 2'b11);

endmodule
