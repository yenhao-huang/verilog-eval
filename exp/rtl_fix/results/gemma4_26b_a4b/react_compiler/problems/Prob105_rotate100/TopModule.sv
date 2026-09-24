module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: q <= {q[0], q[99:1]}; // Right rotate: bit 0 moves to bit 99, bit 99 moves to bit 98, etc.
                2'b10: q <= {q[98:0], q[99]}; // Left rotate: bit 99 moves to bit 0, bit 0 moves to bit 1, etc.
                default: q <= q; // 2'b00 and 2'b11 do not rotate.
            endcase
        end
    end

endmodule
