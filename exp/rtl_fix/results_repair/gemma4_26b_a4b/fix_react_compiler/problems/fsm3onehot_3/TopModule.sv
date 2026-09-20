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
    // State | Next state in=0, Next state in=1 | Output
    // A | A, B | 0
    // B | C, B | 0
    // C | A, D | 0
    // D | C, B | 1

    // next_state[A] = (state[A] & ~in) | (state[C] & ~in)
    next_state[A] = (state[A] | state[C]) & ~in;
    
    // next_state[B] = (state[A] & in) | (state[B] & in) | (state[D] & in)
    next_state[B] = (state[A] | state[B] | state[D]) & in;
    
    // next_state[C] = (state[B] & ~in) | (state[D] & ~in)
    next_state[C] = (state[B] | state[D]) & ~in;
    
    // next_state[D] = (state[C] & in)
    next_state[D] = state[C] & in;
end

assign out = state[D];

endmodule
