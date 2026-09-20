module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	// 4-bit encodings so that all nine states have unique values
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

	assign f = (state_reg == B);
	assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state_reg <= A;
		end else begin
			state_reg <= next_state_reg;
		end
	end

	always @* begin
		case (state_reg)
			A:   next_state_reg = B;
			B:   next_state_reg = S0;
			S0:  next_state_reg = x ? S1  : S0;   // waiting for first 1
			S1:  next_state_reg = x ? S1  : S10;  // saw 1, waiting for 0
			S10: next_state_reg = x ? G1  : S0;   // saw 1,0, waiting for 1
			G1:  next_state_reg = y ? P1  : G2;   // g=1, check y (1st cycle)
			G2:  next_state_reg = y ? P1  : P0;   // g=1, check y (2nd cycle)
			P0:  next_state_reg = P0;             // g = 0 permanently
			P1:  next_state_reg = P1;             // g = 1 permanently
			default: next_state_reg = A;
		endcase
	end

endmodule
