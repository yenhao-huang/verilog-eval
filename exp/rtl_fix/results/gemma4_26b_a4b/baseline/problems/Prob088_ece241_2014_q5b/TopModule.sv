module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot encoding for states A and B
    // In one-hot encoding, each state is represented by a single bit being high.
    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;

    reg [1:0] state;

    // Sequential logic for state transitions
    // The reset is asynchronous and active-high as per the requirements.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset into state A
            state <= STATE_A;
        end else begin
            case (state)
                STATE_A: begin
                    if (x == 1'b1) begin
                        // A --x=1 (z=1)--> B
                        state <= STATE_B;
                    end else begin
                        // A --x=0 (z=0)--> A
                        state <= STATE_A;
                    end
                end
                STATE_B: begin
                    // B --x=0 (z=1)--> B
                    // B --x=1 (z=0)--> B
                    // In both cases, the next state is B.
                    state <= STATE_B;
                end
                default: begin
                    // Safety fallback to state A
                    state <= STATE_A;
                end
            endcase
        end
    end

    // Combinational logic for Mealy output
    // In a Mealy machine, the output depends on both the current state and the input.
    always @(*) begin
        case (state)
            STATE_A: begin
                // A --x=0 (z=0)--> A
                // A --x=1 (z=1)--> B
                z = x;
            end
            STATE_B: begin
                // B --x=0 (z=1)--> B
                // B --x=1 (z=0)--> B
                z = ~x;
            end
            default: begin
                z = 1'b0;
            end
        endcase
    end

endmodule
