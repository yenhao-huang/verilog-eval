module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to weakly not-taken (2'b01)
            state <= 2'b01;
        end else if (train_valid) begin
            // If training is valid, update the counter based on train_taken
            if (train_taken && state < 2'b11) begin
                // Increment up to a maximum of 3
                state <= state + 1'b1;
            end else if (!train_taken && state > 2'b00) begin
                // Decrement down to a minimum of 0
                state <= state - 1'b1;
            end
            // If state is 3 and train_taken is 1, or state is 0 and train_taken is 0, 
            // the counter saturates (remains unchanged).
        end
        // If train_valid is 0, state remains unchanged.
    end

endmodule
