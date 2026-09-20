module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    parameter S_RESET = 4'd0;
    parameter S_F = 4'd1;
    parameter S_X_WAIT = 4'd2;
    parameter S_X1 = 4'd3;
    parameter S_X10 = 4'd4;
    parameter S_G1_0 = 4'd5;
    parameter S_G1_1 = 4'd6;
    parameter S_G1_PERM = 4'd7;
    parameter S_G0_PERM = 4'd8;

    reg [3:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
        end else begin
            case (state)
                S_RESET: begin
                    state <= S_F;
                end
                S_F: begin
                    state <= S_X_WAIT;
                end
                S_X_WAIT: begin
                    if (x)
                        state <= S_X1;
                    else
                        state <= S_X_WAIT;
                end
                S_X1: begin
                    if (!x)
                        state <= S_X10;
                    else
                        state <= S_X1;
                end
                S_X10: begin
                    if (x)
                        state <= S_G1_0;
                    else
                        state <= S_X_WAIT;
                end
                S_G1_0: begin
                    if (y)
                        state <= S_G1_PERM;
                    else
                        state <= S_G1_1;
                end
                S_G1_1: begin
                    if (y)
                        state <= S_G1_PERM;
                    else
                        state <= S_G0_PERM;
                end
                S_G1_PERM: begin
                    state <= S_G1_PERM;
                end
                S_G0_PERM: begin
                    state <= S_G0_PERM;
                end
                default: begin
                    state <= S_RESET;
                end
            endcase
        end
    end

    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case (state)
            S_F: f = 1'b1;
            S_G1_0: g = 1'b1;
            S_G1_1: g = 1'b1;
            S_G1_PERM: g = 1'b1;
            default: ;
        endcase
    end

endmodule
