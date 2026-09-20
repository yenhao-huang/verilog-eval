module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);

    // A 2-to-1 multiplexer is a combinational circuit.
    // The erroneous implementation attempted to use a clock (clk) that was not defined
    // and treated the mux as a sequential circuit.
    // We use 'always @(*)' to create combinational logic.
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
    end

endmodule
