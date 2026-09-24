module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

parameter A = 4'd0;
parameter B = 4'd1;
parameter S0 = 4'd2;
parameter S1 = 4'd3;
parameter S10 = 4'd4;
parameter G1 = 4'd5;
parameter G2 = 4'd6;
parameter P1 = 4'd7;
parameter P0 = 4'd8;

reg [3:0] state;
reg [3:0] next_state;

assign f = (state == B);
assign g = (state == G1 || state == G2 || state == P1);

always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

always @* begin
    case (state)
        A: next_state = B;
        B: next_state = S0;
        S0: begin
            if (x) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (x) next_state = S1;
            else next_state = S10;
        end
        S10: begin
            if (x) next_state = G1;
            else next_state = S0;
        end
        G1: begin
            if (y) next_state = P1;
            else next_state = G2;
        end
        G2: begin
            if (y) next_state = P1;
            else next_state = P0;
        end
        P1: next_state = P1;
        P0: next_state = P0;
        default: next_state = A;
    endcase
end

endmodule
