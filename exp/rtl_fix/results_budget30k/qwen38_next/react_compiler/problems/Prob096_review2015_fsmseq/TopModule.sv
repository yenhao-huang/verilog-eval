module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    localparam [2:0] S_IDLE = 3'd0, // no useful prefix matched
                     S_1    = 3'd1, // matched "1"
                     S_11   = 3'd2, // matched "11"
                     S_110  = 3'd3, // matched "110"
                     S_FOUND= 3'd4; // matched "1101"

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (data)
                        state <= S_1;
                    else
                        state <= S_IDLE;
                end

                S_1: begin
                    if (data)
                        state <= S_11;
                    else
                        state <= S_IDLE;
                end

                S_11: begin
                    if (data)
                        state <= S_11;   // "111" -> still ends with "11"
                    else
                        state <= S_110;
                end

                S_110: begin
                    if (data)
                        state <= S_FOUND;
                    else
                        state <= S_IDLE; // "1100" has no useful prefix suffix
                end

                S_FOUND: begin
                    state <= S_FOUND;    // stay asserted until reset
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

    assign start_shifting = (state == S_FOUND);

endmodule
