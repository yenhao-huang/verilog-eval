module TopModule (
    input  clk,
    input  d,
    output q
);

    reg p, n;

    assign q = p ^ n;

    initial begin
        p = 1'b0;
        n = 1'b0;
    end

    always @(posedge clk) begin
        p <= d ^ n;
    end

    always @(negedge clk) begin
        n <= d ^ p;
    end

endmodule
