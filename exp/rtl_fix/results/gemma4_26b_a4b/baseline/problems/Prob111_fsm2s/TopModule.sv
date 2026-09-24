module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State register
    reg state;

    // State transition logic
    // This is a synchronous process triggered on the rising edge of the clock.
    // The reset is active-high and synchronous.
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    // OFF (out=0) --j=0--> OFF
                    // OFF (out=0) --j=1--> ON
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    // ON (out=1) --k=0--> ON
                    // ON (out=1) --k=1--> OFF
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
                default: begin
                    state <= OFF;
                end
            endcase
        end
    end

    // Output logic
    // Since this is a Moore machine, the output depends only on the current state.
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule
