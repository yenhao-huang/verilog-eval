module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);
parameter A = 0;
parameter B = 1;
parameter S0 = 2;
parameter S1 = 3;
parameter S10 = 4;
parameter G1 = 5;
parameter G2 = 6;
parameter P0 = 7;
parameter P1 = 8;

reg [3:0] state_reg;
reg [3:0] state_next;

// state register (synchronous, active-low reset)
always @(posedge clk) begin
    if (!resetn)
        state_reg <= A;
    else
        state_reg <= state_next;
end

// next-state logic
always @(*) begin
    state_next = state_reg;
    case (state_reg)
        A:  state_next = resetn ? B  : A;
        B:  state_next = S0;
        S0: state_next = x ? S1 : S0;
        S1: state_next = x ? S1 : S10;
        S10:state_next = x ? G1 : S0;
        G1: state_next = y ? P1 : G2;
        G2: state_next = y ? P1 : P0;
        P0: state_next = P0;
        P1: state_next = P1;
        default: state_next = A;
    endcase
end

// outputs: f = 1 for one cycle (state B); g = 1 in G1, G2, P1
assign f = (state_reg == B);
assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);

endmodule
