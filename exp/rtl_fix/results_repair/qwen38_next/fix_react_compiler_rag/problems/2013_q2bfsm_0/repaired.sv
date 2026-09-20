module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	// 9 states require 4-bit encodings (2'b100, 2'b101, ... were truncated to 2 bits)
	parameter A   = 4'd0;
	parameter B   = 4'd1;
	parameter S0  = 4'd2;
	parameter S1  = 4'd3;
	parameter S10 = 4'd4;
	parameter G1  = 4'd5;
	parameter G2  = 4'd6;
	parameter P0  = 4'd7;
	parameter P1  = 4'd8;

	reg [3:0] state_reg;
	reg [3:0] next_state_reg;

	assign f = (state_reg == B);
	assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);

	// synchronous, active-low reset
	always @(posedge clk) begin
		if (~resetn)
			state_reg <= A;
		else
			state_reg <= next_state_reg;
	end

	always @* begin
		case (state_reg)
			A:    next_state_reg = B;
			B:    next_state_reg = S0;
			S0:   next_state_reg = x ? S1  : S0;   // looking for first '1'
			S1:   next_state_reg = x ? S1  : S10;  // looking for '0'
			S10:  next_state_reg = x ? G1  : S0;   // looking for second '1'
			G1:   next_state_reg = y ? P1  : G2;   // y within 1 cycle
			G2:   next_state_reg = y ? P1  : P0;   // y within 2 cycles
			P0:   next_state_reg = P0;             // g = 0 permanently
			P1:   next_state_reg = P1;             // g = 1 permanently
			default: next_state_reg = A;
		endcase
	end

endmodule
