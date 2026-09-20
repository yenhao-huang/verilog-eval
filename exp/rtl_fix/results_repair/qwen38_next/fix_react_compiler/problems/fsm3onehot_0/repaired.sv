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
    next_state[A] = ~in & (state[A] | state[C]);
    next_state[B] =  in & (state[A] | state[B] | state[D]);
    next_state[C] = ~in & (state[B] | state[D]);
    next_state[D] =  in & state[C];
end

assign out = state[D];

endmodule
