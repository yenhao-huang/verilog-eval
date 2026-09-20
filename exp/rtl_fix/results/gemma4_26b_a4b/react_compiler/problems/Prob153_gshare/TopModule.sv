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

    reg [6:0] ghr;
    reg [1:0] pht [0:127];

    integer i;

    // Prediction outputs
    assign predict_history = ghr;
    assign predict_taken = pht[predict_pc ^ ghr][1];

    // GHR update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

    // PHT update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc ^ train_history] < 2'b11) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end
            end else begin
                if (pht[train_pc ^ train_history] > 2'b00) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
            end
        end
    end

endmodule
