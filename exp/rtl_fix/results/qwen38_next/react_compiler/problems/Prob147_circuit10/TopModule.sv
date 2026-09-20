module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg s;

    always @(posedge clk) begin
        s <= (a & b) | (b & s) | (s & a);
    end

    assign state = s;
    assign q     = a ^ b ^ s;

endmodule
