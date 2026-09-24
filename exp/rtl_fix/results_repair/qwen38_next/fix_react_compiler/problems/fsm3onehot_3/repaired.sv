module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

    // One-hot encoding: A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;
    localparam D = 2'd3;

    always @(*) begin
        next_state = 4'b0000;

        if (in == 1'b0) begin
            // in = 0:  A->A, B->C, C->A, D->C
            next_state[A] = state[A] | state[C];
            next_state[B] = 1'b0;
            next_state[C] = state[B] | state[D];
            next_state[D] = 1'b0;
        end else begin
            // in = 1:  A->B, B->B, C->D, D->B
            next_state[A] = 1'b0;
            next_state[B] = state[A] | state[B] | state[D];
            next_state[C] = 1'b0;
            next_state[D] = state[C];
        end
    end

    assign out = state[D];

endmodule
