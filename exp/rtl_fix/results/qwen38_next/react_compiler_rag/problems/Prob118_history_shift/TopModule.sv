module TopModule (
    input             clk,
    input             areset,
    input             predict_valid,
    input             predict_taken,
    input             train_mispredicted,
    input             train_taken,
    input      [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'd0;
        end else if (train_mispredicted) begin
            // Roll back: history before the mispredicted branch,
            // with the actual branch outcome shifted in at the LSB side.
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // New prediction: shift in predicted direction at LSB side.
            predict_history <= {predict_history[30:0], predict_taken};
        end
    end

endmodule
