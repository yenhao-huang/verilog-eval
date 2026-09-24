module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    /*
     * Analysis of the provided simulation waveform:
     * 
     * Time | a | b | c | d | q
     * -----------------------
     * 0ns  | 0 | 0 | 0 | 0 | 0
     * 20ns | 0 | 0 | 0 | 1 | 0
     * 25ns | 0 | 0 | 1 | 0 | 1
     * 30ns | 0 | 0 | 1 | 1 | 1
     * 35ns | 0 | 1 | 0 | 0 | 1
     * 40ns | 0 | 1 | 0 | 1 | 1
     * 45ns | 0 | 1 | 1 | 0 | 1
     * 50ns | 0 | 1 | 1 | 1 | 1
     * 55ns | 1 | 0 | 0 | 0 | 0
     * 60ns | 1 | 0 | 0 | 1 | 0
     * 65ns | 1 | 0 | 1 | 0 | 1
     * 70ns | 1 | 0 | 1 | 1 | 1
     * 75ns | 1 | 1 | 0 | 0 | 1
     * 80ns | 1 | 1 | 0 | 1 | 1
     * 85ns | 1 | 1 | 1 | 0 | 1
     * 90ns | 1 | 1 | 1 | 1 | 1
     * 
     * Truth Table Summary (q=1):
     * (a,b,c,d) -> q
     * 0010 -> 1
     * 0011 -> 1
     * 0100 -> 1
     * 0101 -> 1
     * 0110 -> 1
     * 0111 -> 1
     * 1010 -> 1
     * 1011 -> 1
     * 1100 -> 1
     * 1101 -> 1
     * 1110 -> 1
     * 1111 -> 1
     * 
     * Looking at the patterns:
     * q is 1 whenever b is 1 OR whenever c is 1.
     * Let's test q = b | c:
     * - If b=0, c=0: q=0 (Matches 0, 20, 55, 60ns)
     * - If b=0, c=1: q=1 (Matches 25, 30, 65, 70ns)
     * - If b=1, c=0: q=1 (Matches 35, 40, 75, 80ns)
     * - If b=1, c=1: q=1 (Matches 45, 50, 85, 90ns)
     * 
     * The circuit implements the logical OR function of inputs b and c.
     */

    assign q = b | c;

endmodule
