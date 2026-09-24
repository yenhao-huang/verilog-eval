module top_module (
	input c,
	input d,
	output [3:0] mux_in
);

// Combinational logic driving the 4-to-1 mux data inputs (select = {a,b})
assign mux_in[0] = c | d;      // ab = 00 -> 0,1,1,1 over cd = 00,01,11,10
assign mux_in[1] = 1'b0;       // ab = 01 -> all 0
assign mux_in[2] = c & d;      // ab = 11 -> only cd = 11 is 1
assign mux_in[3] = c | ~d;     // ab = 10 -> all 1 except cd = 01

endmodule
