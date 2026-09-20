module top_module (
	input [1023:0] in,
	input [7:0] sel,
	output [3:0] out
);

    // Error in original code: an extra "clk" input was declared (and the logic was
    // made sequential), so the testbench left port 3 (clk) floating -> the mux
    // never updated. Fix: keep the required header and implement the 256:1 mux
    // combinationally with an indexed part-select.
    // {sel, 2'b00} == sel*4 computed in a 10-bit width (no overflow for sel=255).
    assign out = in[{sel, 2'b00} +: 4];

endmodule
