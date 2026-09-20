module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg a_prev;

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4;
        end else begin
            if (a_prev == 1'b0) begin
                q <= (q + 3'd1) % 3'd7;
            end else begin
                q <= 3'd4;
            end
        end
        a_prev <= a;
    end

endmodule
