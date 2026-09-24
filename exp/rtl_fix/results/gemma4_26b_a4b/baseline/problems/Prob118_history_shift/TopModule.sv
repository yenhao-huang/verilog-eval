module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    // Internal register to hold the 32-bit global history
    reg [31:0] history_reg;

    /**
     * The history register is updated on the positive edge of the clock.
     * An asynchronous reset (areset) is supported on the positive edge.
     */
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: clear the history to zero
            history_reg <= 32'b0;
        end else begin
            /**
             * Precedence Rule:
             * If both a prediction and a misprediction occur at the same time,
             * the misprediction takes precedence. This is because a pipeline 
             * flush caused by a misprediction will invalidate the current 
             * prediction being made.
             */
            if (train_mispredicted) begin
                /**
                 * Misprediction Rollback:
                 * Load the history register with the state after the mispredicted branch.
                 * The state after the branch is defined as the history before the branch 
                 * (train_history) concatenated with the actual result (train_taken).
                 * 
                 * Since the register is 32 bits and predict_history[0] is the youngest,
                 * we shift the 31 most recent bits of the old history and place the 
                 * actual result at the LSB (index 0).
                 */
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                /**
                 * Prediction Update:
                 * When a prediction is made, shift in the predicted direction (predict_taken)
                 * from the LSB side. Since predict_history[0] is the youngest branch,
                 * the new bit becomes index 0, and existing bits shift towards the MSB.
                 */
                history_reg <= {history_reg[30:0], predict_taken};
            end
            // If neither condition is met, the history remains unchanged.
        end
    end

    // Output the current state of the history register
    assign predict_history = history_reg;

endmodule
