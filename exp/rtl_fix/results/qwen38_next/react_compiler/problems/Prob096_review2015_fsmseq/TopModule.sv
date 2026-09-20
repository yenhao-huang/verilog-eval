module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    localparam [2:0] S_IDLE = 3'd0,   // nothing matched
                     S_1    = 3'd1,   // matched "1"
                     S_11   = 3'd2,   // matched "11"
                     S_110  = 3'd3,   // matched "110"
                     S_DONE = 3'd4;   // matched "1101"

    reg [2:0] state;

    // Synchronous, active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: state <= data ? S_1   : S_IDLE;  // "1"
                S_1:    state <= data ? S_11  : S_IDLE;  // "11" / "10"->restart
                S_11:   state <= data ? S_11  : S_110;   // "111"->"11", "110"
                S_110:  state <= data ? S_DONE: S_IDLE;  // "1101" found / "1100"->restart
                S_DONE: state <= S_DONE;                 // stay set until reset
                default: state <= S_IDLE;
            endcase
        end
    end

    assign start_shifting = (state == S_DONE);

endmodule
