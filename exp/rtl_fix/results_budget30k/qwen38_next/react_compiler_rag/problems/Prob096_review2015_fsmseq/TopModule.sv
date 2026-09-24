module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding: number of bits of "1101" matched so far
    localparam IDLE  = 2'd0,   // matched ""
               ONE   = 2'd1,   // matched "1"
               TWO   = 2'd2,   // matched "11"
               THREE = 2'd3;   // matched "110"

    reg [1:0] state;
    reg       done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            if (done) begin
                // Latched high until reset
                done <= 1'b1;
            end else begin
                case (state)
                    IDLE: begin
                        if (data)
                            state <= ONE;
                        else
                            state <= IDLE;
                    end
                    ONE: begin
                        if (data)
                            state <= TWO;
                        else
                            state <= IDLE;      // "10" -> no prefix matched
                    end
                    TWO: begin
                        if (!data)
                            state <= THREE;
                        else
                            state <= TWO;       // "111" -> still matched "11"
                    end
                    THREE: begin
                        if (data) begin
                            state <= IDLE;
                            done  <= 1'b1;      // found "1101"
                        end else begin
                            state <= IDLE;      // "1100" -> no prefix matched
                        end
                    end
                    default: state <= IDLE;
                endcase
            end
        end
    end

    assign start_shifting = done;

endmodule
