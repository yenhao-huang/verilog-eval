module mux_dff(
    input clk,
    input L,
    input r,
    input next_val,
    output reg q
);
always @(posedge clk) begin
    if (L) q <= r;
    else q <= next_val;
end
endmodule

module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

wire [2:0] q;

mux_dff m2 (.clk(clk), .L(L), .r(r_in), .next_val(q[1] ^ q[2]), .q(q[2]));
mux_dff m1 (.clk(clk), .L(L), .r(q_in), .next_val(q[0]), .q(q[1]));
mux_dff m0 (.clk(clk), .L(L), .r(r_in), .next_val(q[2]), .q(q[0]));

always @(*) begin
    Q = q[0];
end

endmodule
