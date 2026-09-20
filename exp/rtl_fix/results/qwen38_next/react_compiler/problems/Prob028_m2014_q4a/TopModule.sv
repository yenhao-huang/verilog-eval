module TopModule (
    input  d,
    input  ena,
    output reg q
);

    // D latch: level-sensitive (transparent while ena is high)
    always @(d or ena) begin
        if (ena)
            q <= d;
    end

endmodule
