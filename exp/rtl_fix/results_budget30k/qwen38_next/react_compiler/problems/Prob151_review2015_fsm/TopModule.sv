module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    localparam [3:0] IDLE     = 4'd0,
                     GOT1     = 4'd1,
                     GOT11    = 4'd2,
                     GOT110   = 4'd3,
                     SHIFT1   = 4'd4,
                     SHIFT2   = 4'd5,
                     SHIFT3   = 4'd6,
                     SHIFT4   = 4'd7,
                     COUNTING = 4'd8,
                     DONE     = 4'd9;

    reg [3:0] state, next_state;

    initial state = IDLE;

    // State register (synchronous, active-high synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = data ? GOT1   : IDLE;
            GOT1:     next_state = data ? GOT11  : IDLE;
            GOT11:    next_state = data ? GOT11  : GOT110;
            GOT110:   next_state = data ? SHIFT1 : IDLE;
            SHIFT1:   next_state = SHIFT2;
            SHIFT2:   next_state = SHIFT3;
            SHIFT3:   next_state = SHIFT4;
            SHIFT4:   next_state = COUNTING;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:     next_state = ack ? IDLE : DONE;
            default:  next_state = IDLE;
        endcase
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
            default: ;
        endcase
    end

endmodule
