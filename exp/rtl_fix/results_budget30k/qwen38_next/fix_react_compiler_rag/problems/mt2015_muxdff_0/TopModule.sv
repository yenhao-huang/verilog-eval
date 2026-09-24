module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

// This module is the 1-bit "flip-flop + 2:1 mux" slice.
// The original code's error: full_module (with 3-bit ports r and q) was
// instantiated from top_module and connected to 1-bit signals
// (e.g. .r(r_in), .q(q[0])), which causes the width-mismatch warnings
// "Port 1 (r) of full_module expects 3 bits, got 1 / Padding 2 high bits".
// The hierarchy is backwards: the 3-bit register belongs in the parent,
// and the submodule must be a single-bit register with a mux on its D
// input. Also, "Q <= {q[1]^q[2], q[0], q[2]};" drives a 1-bit reg with a
// 3-bit vector. Fix: make top_module the bit-slice (Q <= L ? r_in : q_in)
// and let the parent wire the three instances together.
always @(posedge clk) begin
    if (L) begin
        Q <= r_in;      // load
    end else begin
        Q <= q_in;      // shift/feedback path selected by the parent
    end
end

endmodule
