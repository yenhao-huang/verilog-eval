module TopModule (
    input  [2:0] y,
    input        w,
    output reg   Y1
);

    // Current state encoding:
    // A = 000, B = 001, C = 010, D = 011, E = 100, F = 101
    // Y1 is the next-state value of y[1].

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // A -> A or B, next y[1] = 0
            3'b001: Y1 = 1'b1; // B -> C or D, next y[1] = 1
            3'b010: Y1 = w;    // C -> E if w=0, D if w=1
            3'b011: Y1 = 1'b0; // D -> F or A, next y[1] = 0
            3'b100: Y1 = w;    // E -> E if w=0, D if w=1
            3'b101: Y1 = 1'b1; // F -> C or D, next y[1] = 1
            default: Y1 = 1'b0;
        endcase
    end

endmodule
