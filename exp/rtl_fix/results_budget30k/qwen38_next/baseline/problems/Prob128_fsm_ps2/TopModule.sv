module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    localparam S_IDLE  = 2'd0;
    localparam S_WAIT2 = 2'd1;
    localparam S_WAIT3 = 2'd2;
    localparam S_DONE  = 2'd3;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in[3])
                        state <= S_WAIT2;
                    else
                        state <= S_IDLE;
                end

                S_WAIT2: begin
                    state <= S_WAIT3;
                end

                S_WAIT3: begin
                    state <= S_DONE;
                end

                S_DONE: begin
                    if (in[3])
                        state <= S_WAIT2;
                    else
                        state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

    assign done = (state == S_DONE);

endmodule
