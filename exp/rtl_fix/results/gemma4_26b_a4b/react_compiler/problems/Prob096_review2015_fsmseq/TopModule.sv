module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

parameter S_IDLE  = 3'd0;
parameter S_1     = 3'd1;
parameter S_11    = 3'd2;
parameter S_110   = 3'd3;
parameter S_FOUND = 3'd4;

reg [2:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            S_IDLE: begin
                if (data) state <= S_1;
                else     state <= S_IDLE;
            end
            S_1: begin
                if (data) state <= S_11;
                else     state <= S_IDLE;
            end
            S_11: begin
                if (data) state <= S_11;
                else     state <= S_110;
            end
            S_110: begin
                if (data) begin
                    state <= S_FOUND;
                    start_shifting <= 1'b1;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_FOUND: begin
                state <= S_FOUND;
                start_shifting <= 1'b1;
            end
            default: begin
                state <= S_IDLE;
            end
        endcase
    end
end

endmodule
