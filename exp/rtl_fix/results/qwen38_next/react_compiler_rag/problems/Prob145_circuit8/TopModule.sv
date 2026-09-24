module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    // p is a latch: transparent when clock is high, holds when clock is low.
    always @(*) begin
        if (clock)
            p = a;
    end

    // q samples p on the falling edge of clock.
    always @(negedge clock) begin
        q <= p;
    end

endmodule
