module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);
    // One-hot state bit indices: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;

    // Combinational next-state logic (by inspection of the state table)
    always @(*) begin
        next_state[A] = (~in) & (state[A] | state[C]);
        next_state[B] = in    & (state[A] | state[B] | state[D]);
        next_state[C] = (~in) & (state[B] | state[D]);
        next_state[D] = in    & state[C];
    end

    // Moore output
    assign out = state[D];
endmodule
