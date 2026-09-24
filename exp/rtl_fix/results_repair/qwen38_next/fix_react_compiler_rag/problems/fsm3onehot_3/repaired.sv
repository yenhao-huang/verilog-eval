module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	localparam A = 0;
	localparam B = 1;
	localparam C = 2;
	localparam D = 3;

	always @(*) begin
		next_state = 4'b0000;
		if (!in) begin
			next_state[A] = state[A] | state[C];
			next_state[C] = state[B] | state[D];
		end else begin
			next_state[B] = state[A] | state[B] | state[D];
			next_state[D] = state[C];
		end
	end

	assign out = state[D];

endmodule
