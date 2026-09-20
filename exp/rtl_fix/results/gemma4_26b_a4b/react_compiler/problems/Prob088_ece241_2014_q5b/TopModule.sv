module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot encoding: State A is 1'b01, State B is 1'b10
    reg [1:0] state;
    parameter STATE_A = 2'b01;
    parameter STATE_B = 2'b10;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            case (state)
                STATE_A: begin
                    if (x)
                        state <= STATE_B;
                    else
                        state <= STATE_A;
                end
                STATE_B: begin
                    state <= STATE_B;
                end
                default: begin
                    state <= STATE_A;
                end
            endcase
        end
    end

    // Mealy machine: output depends on current state and input x
    always @(*) begin
        case (state)
            STATE_A: begin
                // A --x=0 (z=0)--> A
                // A --x=1 (z=1)--> B
                if (x)
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            STATE_B: begin
                // B --x=0 (z=1)--> B
                // B --x=1 (z=0)--> B
                if (x)
                    z = 1'b0;
                else
                    z = 1'b1;
            end
            default: z = 1'b0;
        endcase
    end

endmodule
