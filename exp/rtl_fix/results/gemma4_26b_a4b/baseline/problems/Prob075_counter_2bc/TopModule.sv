module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // Internal register to hold the 2-bit counter value
    reg [1:0] counter;

    // Sequential logic block
    // areset is an asynchronous positive edge triggered reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset the counter to weakly not-taken (2'b01)
            counter <= 2'b01;
        end else begin
            // Only update the counter if train_valid is high
            if (train_valid) begin
                if (train_taken) begin
                    // Increment the counter if train_taken is high, 
                    // saturating at the maximum value (2'b11)
                    if (counter != 2'b11) begin
                        counter <= counter + 1'b1;
                    end
                end else begin
                    // Decrement the counter if train_taken is low, 
                    // saturating at the minimum value (2'b00)
                    if (counter != 2'b00) begin
                        counter <= counter - 1'b1;
                    end
                end
            end
            // If train_valid is 0, the counter retains its current value
        end
    end

    // Assign the internal counter value to the output port
    assign state = counter;

endmodule
