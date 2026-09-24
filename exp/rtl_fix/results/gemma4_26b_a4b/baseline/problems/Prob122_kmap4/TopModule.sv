module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    /*
     * The provided Karnaugh map is:
     * 
     *              ab
     *   cd   00  01  11  10
     *   00 | 0 | 1 | 0 | 1 |
     *   01 | 1 | 0 | 1 | 0 |
     *   11 | 0 | 1 | 0 | 1 |
     *   10 | 1 | 0 | 1 | 0 |
     * 
     * Let's analyze the truth table for the given map:
     * (a,b,c,d) | out
     * ---------|----
     * (0,0,0,0) | 0
     * (0,1,0,0) | 1
     * (1,1,0,0) | 0
     * (1,0,0,0) | 1
     * (0,0,0,1) | 1
     * (0,1,0,1) | 0
     * (1,1,0,1) | 1
     * (1,0,0,1) | 0
     * (0,0,1,1) | 0
     * (0,1,1,1) | 1
     * (1,1,1,1) | 0
     * (1,0,1,1) | 1
     * (0,0,1,0) | 1
     * (0,1,1,0) | 0
     * (1,1,1,0) | 1
     * (1,0,1,0) | 0
     * 
     * By observing the pattern, the output 'out' is 1 if and only if 
     * the number of 1s in the input (a, b, c, d) is odd.
     * This is the definition of the 4-input XOR function (parity function).
     * 
     * Logic: out = a ^ b ^ c ^ d
     */

    assign out = a ^ b ^ c ^ d;

endmodule
