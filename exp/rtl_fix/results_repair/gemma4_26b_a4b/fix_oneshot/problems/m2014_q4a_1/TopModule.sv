module top_module (
	input d,
	input ena,
	output logic q
);

// A D latch is level-sensitive, not edge-triggered.
// In SystemVerilog, 'always_latch' is used to explicitly describe latch logic.
// When 'ena' is high, the output 'q' follows the input 'd'.
// When 'ena' is low, 'q' retains its previous value.
always_latch begin
	if (ena)
		q <= d;
end

endmodule
