module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    // S0: Initial state, looking for '1'
    // S1: Found '1', looking for '0'
    // S2: Found '10', looking for '1'
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Sequential logic: State transitions
    // Triggered on the positive edge of the clock with an asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic: Next state and Mealy output
    // In a Mealy machine, the output z depends on both the current state and the input x.
    always @(*) begin
        // Default values
        next_state = S0;
        z = 1'b0;

        case (state)
            S0: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end

            S1: begin
                if (x) begin
                    next_state = S1; // Stay in S1 if we get another '1'
                end else begin
                    next_state = S2;
                end
            end

            S2: begin
                if (x) begin
                    // Sequence "101" detected
                    z = 1'b1;
                    // Overlapping: The current '1' acts as the first '1' for the next sequence
                    next_state = S1;
                end else begin
                    // Sequence broken, return to start
                    next_state = S0;
                end
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule
