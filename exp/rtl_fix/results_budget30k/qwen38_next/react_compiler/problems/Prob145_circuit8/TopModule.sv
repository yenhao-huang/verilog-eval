module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    // p: latch transparent when clock is high
    always @(*) begin
        if (clock)
            p = a;
    end

    // q: latch transparent when clock is low
    always @(*) begin
        if (!clock)
            q = p;
    end

endmodule
