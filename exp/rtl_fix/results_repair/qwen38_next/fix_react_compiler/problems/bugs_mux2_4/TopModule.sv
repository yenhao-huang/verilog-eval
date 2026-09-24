module top_module (
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out
);

    // Combinational 2-to-1 mux (no clock exists in this design).
    // Equivalent to: assign out = (~sel & a) | (sel & b);
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
    end

endmodule
