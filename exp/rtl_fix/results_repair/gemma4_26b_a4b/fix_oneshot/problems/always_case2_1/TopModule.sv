module top_module (
	input [3:0] in,
	output reg [1:0] pos
);

// A priority encoder is a combinational circuit.
// We use always @(*) to describe combinational logic.
// The priority is determined by checking the bits from the least significant (bit 0) 
// to the most significant (bit 3).
always @(*) begin
    if (in[0]) begin
        pos = 2'b00;
    end else if (in[1]) begin
        pos = 2'b01;
    end else if (in[2]) begin
        pos = 2'b10;
    end else if (in[3]) begin
        pos = 2'b11;
    end else begin
        // If none of the input bits are high, output zero.
        pos = 2'b00;
    end
end

endmodule
