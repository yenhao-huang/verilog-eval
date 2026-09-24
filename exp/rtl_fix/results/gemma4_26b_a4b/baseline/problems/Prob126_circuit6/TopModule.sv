module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

    // The circuit is a combinational lookup table based on the provided waveform.
    // Mapping input 'a' (3 bits) to output 'q' (16 bits):
    // a=0 -> 1232
    // a=1 -> aee0
    // a=2 -> 27d4
    // a=3 -> 5a0e
    // a=4 -> 2066
    // a=5 -> 64ce
    // a=6 -> c526
    // a=7 -> 2f19

    always @(*) begin
        case (a)
            3'd0: q = 16'h1232;
            3'd1: q = 16'haee0;
            3'd2: q = 16'h27d4;
            3'd3: q = 16'h5a0e;
            3'd4: q = 16'h2066;
            3'd5: q = 16'h64ce;
            3'd6: q = 16'hc526;
            3'd7: q = 16'h2f19;
            default: q = 16'h0000;
        endcase
    end

endmodule
