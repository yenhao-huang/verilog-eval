module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define the three states for the FSM
    localparam S   = 2'b00, // Initial state: nothing detected
                 S1  = 2'b01, // State: "1" detected
                 S10 = 2'b10; // State: "10" detected

    reg [1:0] state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) begin
            state <= S;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and Mealy output
    always @(*) begin
        // Default assignments to prevent latch inference
        next_state = S;
        z = 0;

        case (state)
            S: begin
                if (x == 1'b1) begin
                    next_state = S1;
                end else begin
                    next_state = S;
                end
                z = 1'b0;
            end

            S1: begin
                if (x == 1'b0) begin
                    next_state = S10;
                end else begin
                    next_state = S1;
                end
                z = 1'b0;
            end

            S10: begin
                if (x == 1'b1) begin
                    // Sequence "101" detected!
                    // Overlapping: the current '1' is the start of the next potential "101"
                    next_state = S1;
                    z = 1'b1;
                end else begin
                    next_state = S;
                    z = 1'b0;
                end
            end

            default: begin
                next_state = S;
                z = 1'b0;
            end
        endcase
    end

endmodule
