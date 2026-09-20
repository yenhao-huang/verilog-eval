module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    localparam IDLE  = 2'd0; // searching for first byte of a message
    localparam BYTE1 = 2'd1; // received byte 1
    localparam BYTE2 = 2'd2; // received byte 2
    localparam DONE  = 2'd3; // received byte 3, done asserted

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end

                BYTE1: begin
                    state <= BYTE2;
                end

                BYTE2: begin
                    state <= DONE;
                end

                DONE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign done = (state == DONE);

endmodule
