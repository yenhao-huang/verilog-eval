module TopModule (
    input  [2:0] y,
    input        w,
    output reg   Y1
);
    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // A -> A or B, next y[1] = 0
            3'b001: Y1 = 1'b1; // B -> C or D, next y[1] = 1
            3'b010: Y1 = w;    // C -> E or D, next y[1] = w
            3'b011: Y1 = 1'b0; // D -> F or A, next y[1] = 0
            3'b100: Y1 = w;    // E -> E or D, next y[1] = w
            3'b101: Y1 = 1'b1; // F -> C or D, next y[1] = 1
            default: Y1 = 1'b0;
        endcase
    end
endmodule
