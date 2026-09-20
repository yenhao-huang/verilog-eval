module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    /**
     * Based on the provided simulation waveform, we can derive the truth table:
     * 
     * a b c d | q
     * ---------|---
     * 0 0 0 0 | 1
     * 0 0 0 1 | 0
     * 0 0 1 0 | 0
     * 0 0 1 1 | 1
     * 0 1 0 0 | 0
     * 0 1 0 1 | 1
     * 0 1 1 0 | 1
     * 0 1 1 1 | 0
     * 1 0 0 0 | 0
     * 1 0 0 1 | 1
     * 1 0 1 0 | 1
     * 1 0 1 1 | 0
     * 1 1 0 0 | 1
     * 1 1 0 1 | 0
     * 1 1 1 0 | 0
     * 1 1 1 1 | 1
     * 
     * Analyzing the truth table, we see that q is 1 when the number of 
     * high inputs (1s) is even (0, 2, or 4). 
     * This is the behavior of a 4-input XNOR gate.
     * 
     * Logic expression: q = ~(a ^ b ^ c ^ d)
     */

    assign q = ~(a ^ b ^ c ^ d);

endmodule
