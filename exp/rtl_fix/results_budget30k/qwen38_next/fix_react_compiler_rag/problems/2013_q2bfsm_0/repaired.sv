module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);
	// 4-bit encodings, one per state (was 2'b... -> truncated / duplicate encodings)
	parameter A   = 4'b0000;
	parameter B   = 4'b0001;
	parameter S0  = 4'b0010;
	parameter S1  = 4'b0011;
	parameter S10 = 4'b0100;
	parameter G1  = 4'b0101;
	parameter G2  = 4'b0110;
	parameter P0  = 4'b0111;
	parameter P1  = 4'b1000;

	reg [3:0] state_reg;
	reg [3:0] next_state_reg;

	// f = 1 for one cycle (state B); g = 1 while monitoring y (G1,G2) and permanently in P1
	assign f = (state_reg == B);
	assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);

	// state register
	always @(posedge clk or negedge resetn) begin
		if (~resetn)
			state_reg <= A;
		else
			state_reg <= next_state_reg;
	end

	// next-state logic
	always @* begin
		case (state_reg)
			A:    next_state_reg = B;
			B:    next_state_reg = S0;
			S0:   next_state_reg = x ? S1  : S0;    // looking for 1
			S1:   next_state_reg = x ? S1  : S10;   // looking for 0
			S10:  next_state_reg = x ? G1  : S0;    // looking for 1 -> sequence 1,0,1
			G1:   next_state_reg = y ? P1  : G2;    // y within 1 cycle
			G2:   next_state_reg = y ? P1  : P0;    // y within 2 cycles
			P0:   next_state_reg = P0;              // g = 0 permanently
			P1:   next_state_reg = P1;              // g = 1 permanently
			default: next_state_reg = A;
		endcase
	end
endmodule
