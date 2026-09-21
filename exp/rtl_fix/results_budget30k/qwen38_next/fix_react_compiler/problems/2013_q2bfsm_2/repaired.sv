module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	// State encoding
	parameter A  = 4'd0;   // reset / beginning state
	parameter B  = 4'd1;   // f = 1 for one clock cycle
	parameter S0 = 4'd2;   // waiting for first 1 of the 1,0,1 sequence
	parameter S1 = 4'd3;   // saw 1
	parameter S10= 4'd4;   // saw 1,0
	parameter G1 = 4'd5;   // g = 1, 1st cycle monitoring y
	parameter G2 = 4'd6;   // g = 1, 2nd cycle monitoring y
	parameter P0 = 4'd7;   // g = 0 permanently (until reset)
	parameter P1 = 4'd8;   // g = 1 permanently (until reset)

	reg  [3:0] state, next_state;
	reg        f_r, g_r;

	// f and g are wire outputs -> drive them with continuous assignments
	assign f = f_r;
	assign g = g_r;

	// state register : synchronous, active-low reset
	always @(posedge clk) begin
		if (!resetn)
			state <= A;
		else
			state <= next_state;
	end

	// next-state logic
	always @(*) begin
		case (state)
			A:    next_state = B;                    // reset released -> pulse f
			B:    next_state = S0;                   // f high for exactly one cycle
			S0:   next_state = x ? S1  : S0;
			S1:   next_state = x ? S1  : S10;        // extra 1's don't break the sequence
			S10:  next_state = x ? G1  : S0;         // 1,0,1 detected -> g = 1
			G1:   next_state = y ? P1  : G2;         // y within 1 cycle
			G2:   next_state = y ? P1  : P0;         // y within 2 cycles, else fail
			P0:   next_state = P0;
			P1:   next_state = P1;
			default: next_state = A;
		endcase
	end

	// output logic (drives internal regs, which feed the wire outputs)
	always @(*) begin
		f_r = 1'b0;
		g_r = 1'b0;
		case (state)
			B:          f_r = 1'b1;
			G1, G2, P1: g_r = 1'b1;
			default: begin
				f_r = 1'b0;
				g_r = 1'b0;
			end
		endcase
	end

endmodule
