module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Continuous assignment version
    assign out_assign = a & b;

    // Combinational always block version
    reg out_alwaysblock;
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule
