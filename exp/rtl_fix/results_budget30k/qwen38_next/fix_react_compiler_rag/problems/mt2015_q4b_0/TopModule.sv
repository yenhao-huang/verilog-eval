module top_module(
    input x,
    input y,
    output z);

    // z is a wire -> drive it with a continuous assignment (combinational XNOR)
    assign z = ~(x ^ y);

endmodule
