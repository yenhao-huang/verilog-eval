module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    parameter SEARCH = 2'b00;
    parameter BYTE2  = 2'b01;
    parameter BYTE3  = 2'b10;
    parameter DONE   = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = SEARCH;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DONE;
            end
            DONE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

    always @(*) begin
        done = (state == DONE);
    end

endmodule
