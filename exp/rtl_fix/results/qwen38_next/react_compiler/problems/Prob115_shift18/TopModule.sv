module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    initial q = 64'd0;

    always @(posedge clk) begin
        if (load) begin
            q <= data;                 // synchronous load
        end else if (ena) begin
            case (amount)
                2'b00:   q <= {q[62:0], 1'b0};            // shift left 1
                2'b01:   q <= {q[55:0], 8'b0};            // shift left 8
                2'b10:   q <= {q[63], q[63:1]};           // arithmetic shift right 1
                2'b11:   q <= {{8{q[63]}}, q[63:8]};      // arithmetic shift right 8
                default: q <= q;
            endcase
        end
        // when ena == 0 and load == 0, q holds its value
    end

endmodule
