always @(*) begin
    case (in)
        4'b0001, 4'b0000: pos = 2'd0;
        4'b0010, 4'b0011: pos = 2'd1;   // only when bit0 is 0
        4'b0100, 4'b0101, 4'b0110, 4'b0111: pos = 2'd2;
        default: pos = 2'd3;            // bit3 is the only set bit
    endcase
end
