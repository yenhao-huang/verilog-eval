module TopModule (
    input            clk,
    input            areset,
    input            load,
    input            ena,
    input      [3:0] data,
    output reg [3:0] q
);

    // Asynchronous active-high reset, positive edge of clk for logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 4'b0;               // (1) reset clears the register
        end else begin
            if (load) begin
                q <= data;           // (2) load has priority over enable
            end else if (ena) begin
                q <= {1'b0, q[3:1]}; // (3) shift right, q[3] <- 0, q[0] shifted out
            end
            // otherwise hold value
        end
    end

endmodule
