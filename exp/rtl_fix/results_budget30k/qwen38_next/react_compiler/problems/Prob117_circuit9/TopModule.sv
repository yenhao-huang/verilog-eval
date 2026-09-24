module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4;              // load/hold 4 while a is high
        end else begin
            if (q == 3'd6)
                q <= 3'd0;          // wrap around after 6
            else
                q <= q + 3'd1;      // count up while a is low
        end
    end

endmodule
