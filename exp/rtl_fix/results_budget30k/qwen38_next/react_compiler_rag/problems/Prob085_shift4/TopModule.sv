module TopModule (
    input            clk,
    input            areset,
    input            load,
    input            ena,
    input      [3:0] data,
    output reg [3:0] q
);

    // Async active-high reset, priority: areset > load > ena > hold
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 4'b0000;          // reset shift register to zero
        else if (load)
            q <= data;             // parallel load (higher priority than ena)
        else if (ena)
            q <= {1'b0, q[3:1]};   // shift right: q[3] <- 0, q[0] shifted out
        // otherwise hold current value
    end

endmodule
