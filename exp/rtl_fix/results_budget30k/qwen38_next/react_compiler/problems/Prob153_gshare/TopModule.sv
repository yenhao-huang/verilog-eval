module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];
    reg [6:0] bhr;
    integer i;

    // 7-bit indexes formed by XOR-hashing pc with global history
    wire [6:0] predict_index = predict_pc ^ bhr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Prediction: combinational read of the PHT (sees pre-training state)
    assign predict_history = bhr;
    assign predict_taken   = pht[predict_index][1];

    // Branch history register update (training on a mispredict has priority)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bhr <= 7'd0;
        end else if (train_valid && train_mispredicted) begin
            // Restore to the state right after the mispredicted branch executed
            bhr <= {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            bhr <= {bhr[5:0], predict_taken};
        end
    end

    // PHT update with 2-bit saturating counters
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (train_valid) begin
            if (train_taken) begin
                if (pht[train_index] != 2'b11)
                    pht[train_index] <= pht[train_index] + 2'b01;
            end else begin
                if (pht[train_index] != 2'b00)
                    pht[train_index] <= pht[train_index] - 2'b01;
            end
        end
    end

endmodule
