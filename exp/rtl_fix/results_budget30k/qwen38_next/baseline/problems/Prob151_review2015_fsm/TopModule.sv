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

    localparam [3:0] IDLE     = 4'd0;
    localparam [3:0] S1       = 4'd1;
    localparam [3:0] S11      = 4'd2;
    localparam [3:0] S110     = 4'd3;
    localparam [3:0] SHIFT1   = 4'd4;
    localparam [3:0] SHIFT2   = 4'd5;
    localparam [3:0] SHIFT3   = 4'd6;
    localparam [3:0] SHIFT4   = 4'd7;
    localparam [3:0] COUNTING = 4'd8;
    localparam [3:0] DONE     = 4'd9;

    reg [3:0] state;

    // Synchronous reset, positive-edge state register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:     state <= data ? S1 : IDLE;
                S1:       state <= data ? S11 : IDLE;
                S11:      state <= data ? S11 : S110;
                S110:     state <= data ? SHIFT1 : IDLE;
                SHIFT1:   state <= SHIFT2;
                SHIFT2:   state <= SHIFT3;
                SHIFT3:   state <= SHIFT4;
                SHIFT4:   state <= COUNTING;
                COUNTING: state <= done_counting ? DONE : COUNTING;
                DONE:     state <= ack ? IDLE : DONE;
                default:  state <= IDLE;
            endcase
        end
    end

    // Moore outputs
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT1, SHIFT2, SHIFT3, SHIFT4: shift_ena = 1'b1;
            COUNTING:                       counting  = 1'b1;
            DONE:                           done      = 1'b1;
            default: begin
                // outputs remain 0
            end
        endcase
    end

endmodule
