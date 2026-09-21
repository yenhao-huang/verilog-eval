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

    assign out = state[D];

    always @(*) begin
        next_state = 4'b0000;

        next_state[A] = (in == 1'b0) ? (state[A] | state[C]) : 1'b0;
        next_state[B] = (in == 1'b0) ? 1'b0 : (state[A] | state[B] | state[D]);
        next_state[C] = (in == 1'b0) ? (state[B] | state[D]) : 1'b0;
        next_state[D] = (in == 1'b0) ? 1'b0 : state[C];
    end

endmodule
