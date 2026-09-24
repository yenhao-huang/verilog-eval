module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
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

reg [3:0] state;
reg [3:0] next_state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: begin
            next_state = B;
        end
        B: begin
            next_state = S0;
        end
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
        P0: begin
            next_state = P0;
        end
        P1: begin
            next_state = P1;
        end
        default: begin
            next_state = A;
        end
    endcase
end

always @(*) begin
    f = 0;
    g = 0;
    case (state)
        B: f = 1;
        G1, G2, P1: g = 1;
        default: ;
    endcase
end

endmodule
