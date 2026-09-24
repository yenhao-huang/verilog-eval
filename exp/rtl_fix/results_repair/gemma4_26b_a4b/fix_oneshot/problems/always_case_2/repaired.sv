module top_module (
	input [2:0] sel,
	input [3:0] data0,
	input [3:0] data1,
	input [3:0] data2,
	input [3:0] data3,
	input [3:0] data4,
	input [3:0] data5,
	output reg [3:0] out
);

// A multiplexer is a combinational logic circuit. 
// The error in the original code was attempting to use a 'clk' signal 
// that was not defined in the module's input ports.
// We use 'always @(*)' to create combinational logic.

always @(*) begin
	case(sel)
		3'd0: out = data0;
		3'd1: out = data1;
		3'd2: out = data2;
		3'd3: out = data3;
		3'd4: out = data4;
		3'd5: out = data5;
		default: out = 4'b0000;
	endcase
end

endmodule
