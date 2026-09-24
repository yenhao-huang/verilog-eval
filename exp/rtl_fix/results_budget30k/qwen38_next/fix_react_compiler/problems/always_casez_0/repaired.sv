module top_module (
	input [7:0] in,
	output reg [2:0] pos
);

    // Combinational logic: no clock exists in this module.
    // casez items are ordered from bit 0 upward so the FIRST match
    // is the least-significant set bit (priority = lowest index).
    always @(*) begin
        casez (in)
            8'bzzzzzzz1: pos = 3'd0;
            8'bzzzzzz1z: pos = 3'd1;
            8'bzzzzz1zz: pos = 3'd2;
            8'bzzzz1zzz: pos = 3'd3;
            8'bzzz1zzzz: pos = 3'd4;
            8'bzz1zzzzz: pos = 3'd5;
            8'bz1zzzzzz: pos = 3'd6;
            8'b1zzzzzzz: pos = 3'd7;
            default:     pos = 3'd0;   // no bits set
        endcase
    end

endmodule
