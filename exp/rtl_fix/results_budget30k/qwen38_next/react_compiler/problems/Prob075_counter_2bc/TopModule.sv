module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    // Two-bit saturating counter with asynchronous active-high reset.
    // Increment (saturate at 3) when train_valid & train_taken,
    // decrement (saturate at 0) when train_valid & ~train_taken,
    // hold otherwise. Reset loads 2'b01 (weakly not-taken).
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else if (train_valid) begin
            if (train_taken) begin
                if (state != 2'b11)
                    state <= state + 2'b01;
            end else begin
                if (state != 2'b00)
                    state <= state - 2'b01;
            end
        end
    end

endmodule
