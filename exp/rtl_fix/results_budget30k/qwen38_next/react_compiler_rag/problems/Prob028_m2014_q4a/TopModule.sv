module TopModule (
    input  d,
    input  ena,
    output reg q
);

    // D latch: when enable is high, q follows d; otherwise q holds its value.
    // The absence of an else branch (and the use of a level-sensitive always
    // block) infers a latch.
    always @(*) begin
        if (ena)
            q = d;
    end

endmodule
