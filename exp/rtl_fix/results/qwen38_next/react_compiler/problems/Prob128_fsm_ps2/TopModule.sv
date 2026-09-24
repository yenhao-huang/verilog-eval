module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    localparam [1:0] IDLE = 2'd0,   // searching for start of message
                     GOT1 = 2'd1,   // byte 1 received, expect byte 2
                     GOT2 = 2'd2,   // byte 2 received, expect byte 3
                     GOT3 = 2'd3;   // byte 3 received -> done asserted

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // discard bytes until one has in[3] = 1
                    if (in[3])
                        state <= GOT1;
                    else
                        state <= IDLE;
                end
                GOT1: begin
                    state <= GOT2;
                end
                GOT2: begin
                    state <= GOT3;
                end
                GOT3: begin
                    // current in[] is the next byte: check for new message start
                    if (in[3])
                        state <= GOT1;
                    else
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // done is high in the cycle immediately after the 3rd byte was received
    assign done = (state == GOT3);

endmodule
