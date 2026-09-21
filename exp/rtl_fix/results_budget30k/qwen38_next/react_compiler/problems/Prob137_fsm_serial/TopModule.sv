module TopModule (
    input clk,
    input reset,
    input in,
    output done
);
    // State encoding
    localparam IDLE  = 4'd0,   // line idle, looking for start bit (0)
               DATA0 = 4'd1,   // receiving LSB (bit 0)
               DATA1 = 4'd2,
               DATA2 = 4'd3,
               DATA3 = 4'd4,
               DATA4 = 4'd5,
               DATA5 = 4'd6,
               DATA6 = 4'd7,
               DATA7 = 4'd8,   // receiving MSB (bit 7)
               STOP  = 4'd9,   // expecting stop bit (1)
               WAIT  = 4'd10;  // framing error: wait for a stop bit (in == 1)

    reg [3:0] state, next_state;

    // State register (active-high synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:   next_state = in ? IDLE  : DATA0;  // start bit = 0
            DATA0:  next_state = DATA1;               // LSB first: 8 data bits
            DATA1:  next_state = DATA2;
            DATA2:  next_state = DATA3;
            DATA3:  next_state = DATA4;
            DATA4:  next_state = DATA5;
            DATA5:  next_state = DATA6;
            DATA6:  next_state = DATA7;
            DATA7:  next_state = STOP;
            STOP:   next_state = in ? IDLE  : WAIT;   // stop bit must be 1
            WAIT:   next_state = in ? IDLE  : WAIT;   // wait until a stop bit
            default: next_state = IDLE;
        endcase
    end

    // Byte successfully received: stop bit present where expected
    assign done = (state == STOP) && (in == 1'b1);

endmodule
