module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [1:0] state;
    parameter S_IDLE = 2'b00;
    parameter S_FIRST_1 = 2'b01;
    parameter S_FLIP_0 = 2'b10;
    parameter S_FLIP_1 = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (x == 1'b1)
                        state <= S_FIRST_1;
                    else
                        state <= S_IDLE;
                end
                S_FIRST_1: begin
                    if (x == 1'b0)
                        state <= S_FLIP_0;
                    else
                        state <= S_FLIP_1;
                end
                S_FLIP_0: begin
                    if (x == 1'b0)
                        state <= S_FLIP_0;
                    else
                        state <= S_FLIP_1;
                end
                S_FLIP_1: begin
                    if (x == 1'b0)
                        state <= S_FLIP_0;
                    else
                        state <= S_FLIP_1;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    always @(*) begin
        case (state)
            S_IDLE: z = 1'b0;
            S_FIRST_1: z = 1'b1;
            S_FLIP_0: z = 1'b1;
            S_FLIP_1: z = 1'b0;
            default: z = 1'b0;
        endcase
    end

endmodule
