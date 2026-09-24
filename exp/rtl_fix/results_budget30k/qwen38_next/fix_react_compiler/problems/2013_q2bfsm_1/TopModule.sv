module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);
	localparam A  = 0;
	localparam B  = 1;
	localparam S0 = 2;
	localparam S1 = 3;
	localparam S10 = 4;
	localparam G1 = 5;
	localparam G2 = 6;
	localparam P0 = 7;
	localparam P1 = 8;

	reg [3:0] state_reg;
	reg [3:0] state_next;

	// state register (synchronous, active-low reset)
	always @(posedge clk) begin
		if (!resetn)
			state_reg <= A;
		else
			state_reg <= state_next;
	end

	// next-state logic
	always @(*) begin
		state_next = state_reg;      // default, avoids latches
		case (state_reg)
			A:    state_next = B;                     // leave A after reset released
			B:    state_next = S0;                    // f = 1 for exactly one cycle
			S0:   state_next = x ? S1  : S0;          // saw 1
			S1:   state_next = x ? S1  : S10;         // saw 1,1 -> still looking
			S10:  state_next = x ? G1  : S0;          // saw 1,0,1 -> g = 1
			G1:   state_next = y ? P1  : G2;          // y within 1 cycle
			G2:   state_next = y ? P1  : P0;          // y within 2 cycles
			P0:   state_next = P0;                    // g = 0 permanently
			P1:   state_next = P1;                    // g = 1 permanently
			default: state_next = A;
		endcase
	end

	// output logic (continuous assignment: ports stay nets)
	assign f = (state_reg == B);
	assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);
endmodule
