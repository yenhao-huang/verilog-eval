module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // Internal 10-bit register to act as the down-counter
    reg [9:0] counter;

    // Sequential logic triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (load) begin
            // (1) If load = 1, load the internal counter with the 10-bit data
            counter <= data;
        end else begin
            // (2) If load = 0, decrement the counter if it is greater than 0
            if (counter > 0) begin
                counter <= counter - 1;
            end
            // If counter is already 0, it stays 0 (implicit behavior of reg)
        end
    end

    // The terminal count (tc) signal is asserted when the counter reaches 0
    assign tc = (counter == 10'b0);

endmodule
