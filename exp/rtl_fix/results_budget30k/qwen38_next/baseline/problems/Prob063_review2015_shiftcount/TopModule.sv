module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left, inserting data into the LSB.
            // This stores serial data arriving MSB-first correctly.
            q_reg <= {q_reg[2:0], data};
        end else if (count_ena) begin
            // Decrement the 4-bit value.
            q_reg <= q_reg - 1'b1;
        end
    end

    assign q = q_reg;

endmodule
