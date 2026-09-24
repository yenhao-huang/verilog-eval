module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg Y1;

    always @(*) begin
        case (y)
            3'b000:  Y1 = 1'b0;      // A -> A (w=1) or B (w=0), y[1]=0
            3'b001:  Y1 = 1'b1;      // B -> C (w=0) or D (w=1), y[1]=1
            3'b010:  Y1 = w;         // C -> E (w=0, y[1]=0) or D (w=1, y[1]=1)
            3'b011:  Y1 = 1'b0;      // D -> F (w=0) or A (w=1), y[1]=0
            3'b100:  Y1 = w;         // E -> E (w=0, y[1]=0) or D (w=1, y[1]=1)
            3'b101:  Y1 = 1'b1;      // F -> C (w=0) or D (w=1), y[1]=1
            default: Y1 = 1'b0;
        endcase
    end

endmodule
