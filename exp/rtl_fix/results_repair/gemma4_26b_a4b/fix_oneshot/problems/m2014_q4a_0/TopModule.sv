module top_module (
	input d,
	input ena,
	output logic q
);

// A D latch is level-sensitive, not edge-triggered.
// It should respond to the 'ena' signal level.
// In Verilog, a latch is implemented by an always block 
// that does not define an output for all possible input conditions.
always @(*) begin
	if (ena) begin
		q = d;
	end
end

endmodule
