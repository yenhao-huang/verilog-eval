module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Implementation using an assign statement (continuous assignment)
    // The condition selects 'b' if both sel_b1 and sel_b2 are high, otherwise 'a'.
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    // Implementation using a procedural if statement
    // Since this is combinational logic, we use the @(*) sensitivity list.
    // The output must be declared as a reg to be used in a procedural block.
    always @(*) begin
        if (sel_b1 && sel_b2) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule
