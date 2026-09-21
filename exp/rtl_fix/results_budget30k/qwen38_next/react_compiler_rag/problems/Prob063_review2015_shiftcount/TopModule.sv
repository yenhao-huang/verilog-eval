module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // shift in MSB-first: new bit enters at q[3]
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // decrement the value currently held in the register
            q <= q - 1'b1;
        end
    end

endmodule
