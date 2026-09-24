module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    // Define states
    parameter B = 1'b1;
    parameter A = 1'b0;

    reg state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0)
                        state <= A;
                    else
                        state <= B;
                end
                A: begin
                    if (in == 1'b0)
                        state <= B;
                    else
                        state <= A;
                end
                default: state <= B;
            endcase
        end
    end

    // Moore output logic (output depends only on the current state)
    assign out = (state == B);
endmodule
