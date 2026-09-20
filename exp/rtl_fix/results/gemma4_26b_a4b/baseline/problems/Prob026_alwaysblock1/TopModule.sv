module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implementation using an assign statement
    assign out_assign = a & b;

    // Implementation using a combinational always block
    // Note: out_alwaysblock must be declared as a reg type to be used in a procedural block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule
