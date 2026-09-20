module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_A: begin
                    if (in == 1'b0)
                        state <= STATE_B;
                    else
                        state <= STATE_A;
                end
                STATE_B: begin
                    if (in == 1'b0)
                        state <= STATE_A;
                    else
                        state <= STATE_B;
                end
                default: state <= STATE_B;
            endcase
        end
    end

    // Moore machine output logic (output depends only on the current state)
    assign out = (state == STATE_B);

endmodule
