module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    parameter S_RESET = 4'd0,
              S_F_ON = 4'd1,
              S_X_IDLE = 4'd2,
              S_X_1 = 4'd3,
              S_X_10 = 4'd4,
              S_G_ON = 4'd5,
              S_G_WAIT1 = 4'd6,
              S_G_PERM_ON = 4'd7,
              S_G_PERM_OFF = 4'd8;

    reg [3:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
        end else begin
            case (state)
                S_RESET: begin
                    state <= S_F_ON;
                end
                S_F_ON: begin
                    state <= S_X_IDLE;
                end
                S_X_IDLE: begin
                    if (x) state <= S_X_1;
                    else state <= S_X_IDLE;
                end
                S_X_1: begin
                    if (x) state <= S_X_1;
                    else if (!x) state <= S_X_10;
                    else state <= S_X_1; // This case is actually covered by x/!x
                end
                S_X_10: begin
                    if (x) state <= S_G_ON;
                    else state <= S_X_IDLE;
                end
                S_G_ON: begin
                    if (y) state <= S_G_PERM_ON;
                    else state <= S_G_WAIT1;
                end
                S_G_WAIT1: begin
                    if (y) state <= S_G_PERM_ON;
                    else state <= S_G_PERM_OFF;
                end
                S_G_PERM_ON: begin
                    state <= S_G_PERM_ON;
                end
                S_G_PERM_OFF: begin
                    state <= S_G_PERM_OFF;
                end
                default: state <= S_RESET;
            endcase
        end
    end

    always @(*) begin
        f = 0;
        g = 0;
        case (state)
            S_F_ON: f = 1;
            S_G_ON: g = 1;
            S_G_WAIT1: g = 1;
            S_G_PERM_ON: g = 1;
            default: ;
        endcase
    end

endmodule
