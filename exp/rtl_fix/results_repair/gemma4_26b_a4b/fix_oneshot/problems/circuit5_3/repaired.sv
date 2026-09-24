module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [3:0] c, 
	input [3:0] d,
	input [3:0] e,
	output reg [3:0] q
);

// The problem states this is a combinational circuit.
// Based on the simulation waveform:
// When c = 0, q = b
// When c = 1, q = e
// When c = 2, q = a
// When c = 3, q = d
// When c >= 4, q = f (where f is the hex value 4'hf)

always @(*) begin
	case (c)
		4'h0: q = b;
		4'h1: q = e;
		4'h2: q = a;
		4'h3: q = d;
		default: q = 4'hf;
	endcase
end

endmodule
