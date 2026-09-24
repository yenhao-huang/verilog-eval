module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    parameter S_IDLE  = 4'd0;
    parameter S_1     = 4'd1;
    parameter S_2     = 4'd2;
    parameter S_3     = 4'd3;
    parameter S_4     = 4'd4;
    parameter S_5     = 4'd5;
    parameter S_6     = 4'd6;
    parameter S_ERR   = 4'd7;
    parameter S_DISC  = 4'd8;
    parameter S_FLAG  = 4'd9;

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in) state <= S_1;
                    else    state <= S_IDLE;
                end
                S_1: begin
                    if (in) state <= S_2;
                    else    state <= S_IDLE;
                end
                S_2: begin
                    if (in) state <= S_3;
                    else    state <= S_IDLE;
                end
                S_3: begin
                    if (in) state <= S_4;
                    else    state <= S_IDLE;
                end
                S_4: begin
                    if (in) state <= S_5;
                    else    state <= S_IDLE;
                end
                S_5: begin
                    if (in) state <= S_6;
                    else    state <= S_DISC;
                end
                S_6: begin
                    if (in) state <= S_ERR;
                    else    state <= S_FLAG;
                end
                S_ERR: begin
                    if (in) state <= S_ERR;
                    else    state <= S_IDLE;
                end
                S_DISC: begin
                    if (in) state <= S_1;
                    else    state <= S_IDLE;
                end
                S_FLAG: begin
                    if (in) state <= S_1;
                    else    state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        case (state)
            S_DISC: disc = 1;
            S_FLAG: flag = 1;
            S_ERR:  err = 1;
            default: ;
        endcase
    end

endmodule
