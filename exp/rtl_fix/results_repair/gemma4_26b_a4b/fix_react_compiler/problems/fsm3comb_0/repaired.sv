module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

always @(*) begin
	case (state)
		2'b00: next_state = in ? 2'b01 : 2'b00; // State A: in=0 -> A, in=1 -> B
		2'b01: next_state = in ? 2'b01 : 2'b10; // State B: in=0 -> C, in=1 -> B
		2'b10: next_state = in ? 2'b11 : 2'b00; // State C: in=0 -> A, in=1 -> D
		2'b11: next_state = in ? 2'b01 : 2'b10; // State D: in=0 -> C, in=1 -> B
		default: next_state = 2'b00;
	endcase
end

assign out = (state == 2'b11); // Output is 1 only when in state D (2'b11)

endmodule
