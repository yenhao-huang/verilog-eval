module TopModule (
    input  clk,
    input  a,
    output q
);

    reg p;
    reg q;

    always @(posedge clk) begin
        p <= ~a;   // first stage: inverted input
        q <= p;    // second stage: one more clock of delay
    end

endmodule
