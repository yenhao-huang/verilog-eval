module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    /**
     * The truth table provided is:
     * x3 | x2 | x1 | f
     * ----------------
     * 0  | 0  | 0  | 0
     * 0  | 0  | 1  | 0
     * 0  | 1  | 0  | 1
     * 0  | 1  | 1  | 1
     * 1  | 0  | 0  | 0
     * 1  | 0  | 1  | 1
     * 1  | 1  | 0  | 0
     * 1  | 1  | 1  | 1
     *
     * Analysis:
     * When x3 = 0, f = x2.
     * When x3 = 1, f = x1.
     * 
     * This can be expressed as the boolean equation: f = (~x3 & x2) | (x3 & x1)
     * Or as a multiplexer: f = x3 ? x1 : x2
     */

    assign f = (~x3 & x2) | (x3 & x1);

endmodule
