module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    /*
     * Analyzing the provided simulation waveform:
     * 
     * The truth table derived from the waveform is:
     * a b c d | q
     * -------|---
     * 0 0 0 0 | 0
     * 0 0 0 1 | 0
     * 0 0 1 0 | 0
     * 0 0 1 1 | 0
     * 0 1 0 0 | 0
     * 0 1 0 1 | 1
     * 0 1 1 0 | 1
     * 0 1 1 1 | 1
     * 1 0 0 0 | 0
     * 1 0 0 1 | 1
     * 1 0 1 0 | 1
     * 1 0 1 1 | 1
     * 1 1 0 0 | 0
     * 1 1 0 1 | 1
     * 1 1 1 0 | 1
     * 1 1 1 1 | 1
     * 
     * From this table, we can observe the following logic:
     * q is 1 if and only if (a OR b) is true AND (c OR d) is true.
     * 
     * Let's verify:
     * - If a=0, b=0: (a|b) is 0, so q is 0. (Matches 0-30ns)
     * - If c=0, d=0: (c|d) is 0, so q is 0. (Matches 35ns, 55ns, 75ns)
     * - If a=0, b=1, c=0, d=1: (0|1) & (0|1) = 1 & 1 = 1. (Matches 40ns)
     * - If a=1, b=0, c=1, d=0: (1|0) & (1|0) = 1 & 1 = 1. (Matches 65ns)
     * - If a=1, b=1, c=1, d=1: (1|1) & (1|1) = 1 & 1 = 1. (Matches 90ns)
     * 
     * The logic expression is: q = (a | b) & (c | d)
     */

    assign q = (a | b) & (c | d);

endmodule
