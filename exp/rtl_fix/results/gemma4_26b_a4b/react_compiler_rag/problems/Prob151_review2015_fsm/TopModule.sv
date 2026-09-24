module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State definitions
    localparam S_SEARCH    = 3'd0;
    localparam S_1         = 3'd1;
    localparam S_11        = 3'd2;
    localparam S_110       = 3'd3;
    localparam S_SHIFT     = 3'd4;
    localparam S_COUNTING  = 3'd5;
    localparam S_DONE      = 3'd6;

    reg [2:0] state;
    reg [1:0] shift_cnt;

    // State machine logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            shift_cnt <= 2'd0;
        end else begin
            case (state)
                S_SEARCH: begin
                    shift_cnt <= 2'd0;
                    if (data == 1'b1)
                        state <= S_1;
                    else
                        state <= S_SEARCH;
                end
                S_1: begin
                    shift_cnt <= 2'd0;
                    if (data == 1'b1)
                        state <= S_11;
                    else
                        state <= S_SEARCH;
                end
                S_11: begin
                    shift_cnt <= 2'd0;
                    if (data == 1'b0)
                        state <= S_110;
                    else if (data == 1'b1)
                        state <= S_11;
                    else
                        state <= S_SEARCH;
                end
                S_110: begin
                    shift_cnt <= 2'd0;
                    if (data == 1'b1)
                        state <= S_SHIFT;
                    else
                        state <= S_SEARCH;
                end
                S_SHIFT: begin
                    if (shift_cnt == 2'd3) begin
                        state <= S_COUNTING;
                        shift_cnt <= 2'd0;
                    end else begin
                        shift_cnt <= shift_cnt + 1'b1;
                    end
                end
                S_COUNTING: begin
                    if (done_counting)
                        state <= S_DONE;
                    else
                        state <= S_COUNTING;
                end
                S_DONE: begin
                    if (ack)
                        state <= S_SEARCH;
                    else
                        state <= S_DONE;
                end
                default: state <= S_SEARCH;
            endcase
        end
    end

    // Output assignment logic
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        case (state)
            S_SHIFT:    shift_ena = 1'b1;
            S_COUNTING: counting = 1'b1;
            S_DONE:     done = 1'b1;
            default:    begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        endcase
    end

endmodule
