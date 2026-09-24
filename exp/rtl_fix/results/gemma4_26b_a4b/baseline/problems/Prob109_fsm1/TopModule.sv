module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding based on the description:
    // State B is represented by 1
    // State A is represented by 0
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // Moore machine implementation
    // The output depends only on the current state.
    // Based on the diagram, State B outputs 1 and State A outputs 0.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronously reset into state B if areset is high
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: begin
                    if (in == 1'b0) begin
                        // B (1) --0--> A
                        state <= STATE_A;
                    end else begin
                        // B (1) --1--> B
                        state <= STATE_B;
                    end
                end
                STATE_A: begin
                    if (in == 1'b0) begin
                        // A (0) --0--> B
                        state <= STATE_B;
                    end else begin
                        // A (0) --1--> A
                        state <= STATE_A;
                    end
                end
                default: begin
                    state <= STATE_B;
                end
            endcase
        end
    end

    // Assign the output based on the current state (Moore machine property)
    assign out = state;

endmodule
