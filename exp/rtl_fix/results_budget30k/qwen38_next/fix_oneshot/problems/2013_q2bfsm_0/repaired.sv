module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    localparam [3:0] A   = 4'd0;
    localparam [3:0] B   = 4'd1;
    localparam [3:0] S0  = 4'd2;
    localparam [3:0] S1  = 4'd3;
    localparam [3:0] S10 = 4'd4;
    localparam [3:0] G1  = 4'd5;
    localparam [3:0] G2  = 4'd6;
    localparam [3:0] P0  = 4'd7;
    localparam [3:0] P1  = 4'd8;

    reg [3:0] state = A;

    assign f = (state == B);
    assign g = (state == G1 || state == G2 || state == P1);

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A:   state <= B;
                B:   state <= S0;
                S0:  state <= (x ? S1 : S0);
                S1:  state <= (x ? S1 : S10);
                S10: state <= (x ? G1 : S0);
                G1:  state <= (y ? P1 : G2);
                G2:  state <= (y ? P1 : P0);
                P0:  state <= P0;
                P1:  state <= P1;
                default: state <= A;
            endcase
        end
    end

endmodule
