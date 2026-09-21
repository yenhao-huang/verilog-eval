module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    // Master latch: transparent when clock = 1
    always @(a or clock) begin
        if (clock)
            p = a;
    end

    // Slave latch: transparent when clock = 0
    always @(p or clock) begin
        if (!clock)
            q = p;
    end

endmodule
