module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4;              // load 4 when a is high
        end else begin
            if (q == 3'd6)
                q <= 3'd0;          // wrap: counts 0..6 (mod 7)
            else
                q <= q + 3'd1;      // otherwise count up
        end
    end

endmodule
