module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [3:0] c, 
	input [3:0] d,
	input [3:0] e,
	output reg [3:0] q
);

    // Combinational 4-to-1 style multiplexer selected by c.
    // Fix: the original code used "always @(posedge clk)" (and "<=") even though
    // this module has no clk port -> elaboration error "Unable to bind ... `clk`".
    // A purely combinational block must be sensitive to all inputs: always @*
    always @* begin
        case (c)
            4'h0: q = b;
            4'h1: q = e;
            4'h2: q = a;
            4'h3: q = d;
            default: q = 4'hf;
        endcase
    end

endmodule
