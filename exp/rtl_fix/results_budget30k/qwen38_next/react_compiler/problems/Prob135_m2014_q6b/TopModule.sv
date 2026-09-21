module TopModule (
    input  [2:0] y,   // current state: A=000, B=001, C=010, D=011, E=100, F=101
    input        w,
    output       Y1   // next-state value of y[1]
);

    reg Y1;

    always @* begin
        case (y)
            3'b000: Y1 = 1'b0;   // A: -> B (001) or A (000)      => y[1] = 0
            3'b001: Y1 = 1'b1;   // B: -> C (010) or D (011)      => y[1] = 1
            3'b010: Y1 = w;      // C: -> E (100, y1=0) or D (011, y1=1)
            3'b011: Y1 = 1'b0;   // D: -> F (101) or A (000)      => y[1] = 0
            3'b100: Y1 = w;      // E: -> E (100, y1=0) or D (011, y1=1)
            3'b101: Y1 = 1'b1;   // F: -> C (010) or D (011)      => y[1] = 1
            default: Y1 = 1'b0;
        endcase
    end

endmodule
