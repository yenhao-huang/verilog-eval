module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State definitions
    parameter S0 = 2'b00; // Initial state / No sequence detected
    parameter S1 = 2'b01; // Detected "1"
    parameter S2 = 2'b10; // Detected "10"

    reg [1:0] state;
    reg [1:0] next_state;

    // State transition logic (Sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (Combinational)
    always @(*) begin
        case (state)
            S0: begin
                if (x) next_state = S1;
                else   next_state = S0;
            end
            S1: begin
                if (x) next_state = S1;
                else   next_state = S2;
            end
            S2: begin
                if (x) next_state = S1; // Overlapping: "101" -> next state is S1 (detected "1")
                else   next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Mealy output logic
    // Output z is asserted when in state S2 (having seen "10") and the current input x is 1.
    assign z = (state == S2 && x == 1'b1);

endmodule
