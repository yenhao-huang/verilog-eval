module top_module(
    input x,
    input y,
    output z);

    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out, xor_out;

    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    or or_gate(or_out, a1_out, b1_out);
    and and_gate(and_out, a2_out, b2_out);
    xor xor_gate(xor_out, or_out, and_out);

    assign z = xor_out;

endmodule
