module top_module (
	input in1,
	input in2,
	input in3,
	output logic out
);

    // intermediate wire: output of the XNOR gate
    wire xnor_out;

    // XNOR of in1 and in2
    assign xnor_out = ~(in1 ^ in2);   // equivalently: (in1 ~^ in2)

    // XOR of the XNOR result with in3
    assign out = xnor_out ^ in3;

endmodule
