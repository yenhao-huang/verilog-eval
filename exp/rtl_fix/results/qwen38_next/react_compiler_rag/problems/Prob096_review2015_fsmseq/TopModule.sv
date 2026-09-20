module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    localparam [2:0] IDLE    = 3'd0,
                     GOT1    = 3'd1,
                     GOT11   = 3'd2,
                     GOT110  = 3'd3,
                     FOUND   = 3'd4;

    reg [2:0] state;

    initial begin
        state = IDLE;
        start_shifting = 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            // Sticky: assert when the sequence completes, stay asserted
            start_shifting <= (state == FOUND) || (state == GOT110 && data);

            case (state)
                IDLE:    state <= data ? GOT1   : IDLE;     // saw 1
                GOT1:    state <= data ? GOT11  : IDLE;     // saw 11 / restart
                GOT11:   state <= data ? GOT11  : GOT110;   // 111 keeps 11, 110 advances
                GOT110:  state <= data ? FOUND  : IDLE;     // 1101 found / restart
                FOUND:   state <= FOUND;                    // stay found until reset
                default: state <= IDLE;
            endcase
        end
    end

endmodule
