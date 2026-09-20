module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);
    parameter A  = 0;
    parameter B  = 1;
    parameter S0 = 2;
    parameter S1 = 3;
    parameter S10= 4;
    parameter G1 = 5;
    parameter G2 = 6;
    parameter P0 = 7;
    parameter P1 = 8;

    reg [3:0] state_reg;
    reg [3:0] state_next;

    // state register: synchronous, active-low reset
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
            A:   state_next = B;                    // leave A right after reset released
            B:   state_next = S0;                   // f = 1 for one cycle
            S0:  state_next = x   ? S1  : S0;       // saw 1
            S1:  state_next = x   ? S1  : S10;      // still 1 / saw 0
            S10: state_next = x   ? G1  : S0;       // saw 1,0,1
            G1:  state_next = y   ? P1  : G2;       // 1st cycle checking y
            G2:  state_next = y   ? P1  : P0;       // 2nd cycle checking y
            P0:  state_next = P0;                   // g = 0 permanently
            P1:  state_next = P1;                   // g = 1 permanently
            default: state_next = A;
        endcase
    end

    // Moore outputs (driven as nets -> no redeclaration of the ports)
    assign f = (state_reg == B);
    assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);
endmodule
