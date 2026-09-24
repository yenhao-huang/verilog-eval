module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

    reg [3:0] q = 4'b0;

    always @(posedge clk) begin
        if (shift_ena) begin
            // MSB-first shift in
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // down counter
            q <= q - 1'b1;
        end
    end

endmodule
