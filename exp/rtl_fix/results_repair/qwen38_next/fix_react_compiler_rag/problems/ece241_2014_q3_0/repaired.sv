module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

	// Each mux_in[i] is the K-map column selected by ab = i,
	// expressed as a function of c and d (each needs <= 1 two-to-1 mux).
	assign mux_in[0] = c | d;    // ab = 00 -> 0,1,1,1
	assign mux_in[1] = 1'b0;     // ab = 01 -> 0,0,0,0
	assign mux_in[2] = c & d;    // ab = 11 -> 0,0,1,0
	assign mux_in[3] = c | ~d;   // ab = 10 -> 1,0,1,1

endmodule
