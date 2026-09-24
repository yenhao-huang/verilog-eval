module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    /*
     * Based on the provided simulation waveform:
     * When c = 0, q = b
     * When c = 1, q = e
     * When c = 2, q = a
     * When c = 3, q = d
     * For all other values of c (c >= 4), q = 4'hf (represented as 'f' in the table)
     */

    always @(*) begin
        case (c)
            4'h0: q = b;
            4'h1: q = e;
            4'h2: q = a;
            4'h3: q = d;
            default: q = 4'hf;
        endcase
    end

endmodule
