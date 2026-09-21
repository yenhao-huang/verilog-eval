module top_module(
	input clk,
	input reset,
	output shift_ena);

	// FSM states:
	// B0 -> B1 -> B2 -> B3 -> Done
	// B0: first shift cycle, B1: second, B2: third, B3: fourth, Done: finished
	// Synchronous, active-high reset forces the FSM to B0.
	// shift_ena = 1 while in B0, B1, B2 or B3 (exactly 4 cycles after reset).

	localparam B0    = 3'b000,
	           B1    = 3'b001,
	           B2    = 3'b010,
	           B3    = 3'b011,
	           Done  = 3'b100;

	reg [2:0] state;

	always @(posedge clk) begin
		if (reset) begin
			state <= B0;
		end else begin
			case (state)
				B0:      state <= B1;
				B1:      state <= B2;
				B2:      state <= B3;
				B3:      state <= Done;
				default: state <= Done;
			endcase
		end
	end

	assign shift_ena = (state == B0) || (state == B1) ||
	                   (state == B2) || (state == B3);

endmodule
