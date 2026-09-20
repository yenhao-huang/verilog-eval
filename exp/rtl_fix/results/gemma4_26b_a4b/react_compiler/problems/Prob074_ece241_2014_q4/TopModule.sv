module TopModule (
    input clk,
    input x,
    output z
);
    reg dff1_q, dff2_q, dff3_q;

    always @(posedge clk) begin
        dff1_q <= x ^ dff1_q;
        dff2_q <= x & (~dff2_q);
        dff3_q <= x | (~dff3_q);
    end

    initial begin
        dff1_q = 1'b0;
        dff2_q = 1'b0;
        dff3_q = 1'b0;
    end

    assign z = ~(dff1_q | dff2_q | dff3_q);

endmodule
