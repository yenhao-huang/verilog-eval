module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;                 // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                if (state == 2'b11)         // saturate at 3
                    state <= 2'b11;
                else
                    state <= state + 2'd1;  // increment
            end else begin
                if (state == 2'b00)         // saturate at 0
                    state <= 2'b00;
                else
                    state <= state - 2'd1;  // decrement
            end
        end
        // train_valid == 0: state holds its value
    end

endmodule
