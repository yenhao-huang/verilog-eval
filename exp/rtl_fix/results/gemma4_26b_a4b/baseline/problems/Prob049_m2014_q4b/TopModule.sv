module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

    // The asynchronous reset 'ar' is included in the sensitivity list 
    // to ensure the block triggers immediately when 'ar' changes, 
    // regardless of the clock.
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            // Asynchronous reset: q is set to 0 immediately when ar is high
            q <= 1'b0;
        end else begin
            // On the rising edge of the clock, q takes the value of d
            q <= d;
        end
    end

endmodule
