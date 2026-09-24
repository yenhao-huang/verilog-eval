module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    parameter [3:0] A = 4'd0;
    parameter [3:0] B = 4'd1;
    parameter [3:0] S0 = 4'd2;
    parameter [3:0] S1 = 4'd3;
    parameter [3:0] S10 = 4'd4;
    parameter [3:0] G1 = 4'd5;
    parameter [3:0] G2 = 4'd6;
    parameter [3:0] P0 = 4'd7;
    parameter [3:0] P1 = 4'd8;

    reg [3:0] state_reg = A;

    always @(posedge clk) begin
        if (!resetn) begin
            state_reg <= A;
        end else begin
            case (state_reg)
                A:   state_reg <= B;
                B:   state_reg <= S0;
                S0:  state_reg <= (x ? S1 : S0);
                S1:  state_reg <= (x ? S1 : S10);
                S10: state_reg <= (x ? G1 : S0);
                G1:  state_reg <= (y ? P1 : G2);
                G2:  state_reg <= (y ? P1 : P0);
                P0:  state_reg <= P0;
                P1:  state_reg <= P1;
                default: state_reg <= A;
            endcase
        end
    end

    assign f = (state_reg == B);
    assign g = (state_reg == G1) || (state_reg == G2) || (state_reg == P1);

endmodule
