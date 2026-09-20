module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A  = 4'd0;
	parameter B  = 4'd1;
	parameter S0 = 4'd2;
	parameter S1 = 4'd3;
	parameter S10= 4'd4;
	parameter G1 = 4'd5;
	parameter G2 = 4'd6;
	parameter P0 = 4'd7;
	parameter P1 = 4'd8;

	reg [3:0] state;
	reg [3:0] next_state;

	// state register: synchronous, active-low reset
	always @(posedge clk) begin
		if (!resetn)
			state <= A;
		else
			state <= next_state;
	end

	// next-state logic
	always @(*) begin
		case (state)
			A:    next_state = B;                 // after reset de-asserted, enter B
			B:    next_state = S0;                // f = 1 for exactly one cycle
			S0:   next_state = x ? S1  : S0;      // waiting for first 1
			S1:   next_state = x ? S1  : S10;     // saw 1, now need 0
			S10:  next_state = x ? G1  : S0;      // saw 1,0, now need 1
			G1:   next_state = y ? P1  : G2;      // g = 1, check y (1st cycle)
			G2:   next_state = y ? P1  : P0;      // g = 1, check y (2nd cycle)
			P0:   next_state = P0;                // g = 0 permanently
			P1:   next_state = P1;                // g = 1 permanently
			default: next_state = A;
		endcase
	end

	// outputs: continuous assignments (ports are wires, not regs)
	assign f = (state == B);
	assign g = (state == G1) || (state == G2) || (state == P1);

endmodule
