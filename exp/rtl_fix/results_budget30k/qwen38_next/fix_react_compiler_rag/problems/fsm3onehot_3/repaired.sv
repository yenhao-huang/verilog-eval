module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

    // One-hot state encodings: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;

    // State transition logic (by inspection of the one-hot table)
    always @(*) begin
        next_state[A] = (~in) & (state[A] | state[C]);
        next_state[B] = in    & (state[A] | state[B] | state[D]);
        next_state[C] = (~in) & (state[B] | state[D]);
        next_state[D] = in    & state[C];
    end

    // Output logic (Moore: depends only on the state)
    assign out = state[D];

endmodule
