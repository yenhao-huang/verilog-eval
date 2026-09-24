module TopModule (
    input  wire       clk,
    input  wire       x,
    input  wire [2:0] y,
    output reg        Y0,
    output wire       z
);

    // Next state bit Y[0] (combinational, from present state y and input x)
    always @(*) begin
        case (y)
            3'b000:  Y0 = x;        // 000 -> 000 (x=0) / 001 (x=1)
            3'b001:  Y0 = ~x;       // 001 -> 001 (x=0) / 100 (x=1)
            3'b010:  Y0 = x;        // 010 -> 010 (x=0) / 001 (x=1)
            3'b011:  Y0 = ~x;       // 011 -> 001 (x=0) / 010 (x=1)
            3'b100:  Y0 = ~x;       // 100 -> 011 (x=0) / 100 (x=1)
            default: Y0 = 1'b0;     // unused states
        endcase
    end

    // Output logic: z = 1 for present states 011 and 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule
