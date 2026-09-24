module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // One-hot encoding for states A and B
    reg state_A, state_B;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous active-high reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            if (state_A) begin
                if (x) begin
                    // A --x=1--> B
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end else begin
                    // A --x=0--> A
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end
            end else if (state_B) begin
                // B --x=0--> B
                // B --x=1--> B
                state_A <= 1'b0;
                state_B <= 1'b1;
            end
        end
    end

    // Mealy output logic
    // A --x=0 (z=0)--> A
    // A --x=1 (z=1)--> B
    // B --x=0 (z=1)--> B
    // B --x=1 (z=0)--> B
    assign z = (state_A && x) || (state_B && !x);

endmodule
