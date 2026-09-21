module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    parameter IDLE  = 2'd0;
    parameter BYTE2 = 2'd1;
    parameter BYTE3 = 2'd2;

    reg [1:0] state;
    reg       done_r;

    always @(posedge clk) begin
        if (reset) begin
            state  <= IDLE;
            done_r <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE2;   // byte 1 of a message
                    else
                        state <= IDLE;    // discard
                    done_r <= 1'b0;
                end

                BYTE2: begin
                    state  <= BYTE3;      // byte 2 received
                    done_r <= 1'b0;
                end

                BYTE3: begin
                    state  <= IDLE;       // byte 3 received -> message complete
                    done_r <= 1'b1;       // done in the next cycle
                end

                default: begin
                    state  <= IDLE;
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign done = done_r;

endmodule
