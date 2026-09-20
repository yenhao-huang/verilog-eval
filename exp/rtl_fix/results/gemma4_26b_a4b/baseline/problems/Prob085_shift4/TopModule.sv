module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

    // The always block is triggered on the positive edge of the clock 
    // or the positive edge of the asynchronous reset.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // (1) areset: Resets shift register to zero.
            q <= 4'b0000;
        end else begin
            // (4) Priority: load has higher priority than ena.
            if (load) begin
                // (2) load: Loads shift register with data[3:0].
                q <= data;
            end else if (ena) begin
                // (3) ena: Shift right. 
                // q[3] becomes zero, q[0] is shifted out.
                // The concatenation {1'b0, q[3:1]} performs:
                // New q[3] = 0
                // New q[2] = Old q[3]
                // New q[1] = Old q[2]
                // New q[0] = Old q[1]
                q <= {1'b0, q[3:1]};
            end
            // If neither load nor ena is asserted, q retains its current value.
        end
    end

endmodule
