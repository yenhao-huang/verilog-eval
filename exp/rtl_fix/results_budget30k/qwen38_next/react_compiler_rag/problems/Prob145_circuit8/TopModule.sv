module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    // p is a latch enabled (transparent) when clock is high
    always @(a or clock) begin
        if (clock)
            p = a;
    end

    // q is a latch enabled (transparent) when clock is low
    always @(p or clock) begin
        if (!clock)
            q = p;
    end

endmodule
