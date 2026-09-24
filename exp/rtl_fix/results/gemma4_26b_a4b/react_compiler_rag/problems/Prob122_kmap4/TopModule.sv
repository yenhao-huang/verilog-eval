module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // The Karnaugh map provided follows the pattern of a 4-input XOR gate.
    // Let's verify the values:
    // (a,b,c,d) | out
    // (0,0,0,0) | 0^0^0^0 = 0 (Row 00, Col 00)
    // (0,1,0,0) | 0^1^0^0 = 1 (Row 00, Col 01)
    // (1,1,0,0) | 1^1^0^0 = 0 (Row 00, Col 11)
    // (1,0,0,0) | 1^0^0^0 = 1 (Row 00, Col 10)
    // (0,0,0,1) | 0^0^0^1 = 1 (Row 01, Col 00)
    // (0,1,0,1) | 0^1^0^1 = 0 (Row 01, Col 01)
    // (1,1,0,1) | 1^1^0^1 = 1 (Row 01, Col 11)
    // (1,0,0,1) | 1^0^0^1 = 0 (Row 01, Col 10)
    // (0,0,1,1) | 0^0^1^1 = 0 (Row 11, Col 00)
    // (0,1,1,1) | 0^1^1^1 = 1 (Row 11, Col 01)
    // (1,1,1,1) | 1^1^1^1 = 0 (Row 11, Col 11)
    // (1,0,1,1) | 1^0^1^1 = 1 (Row 11, Col 10)
    // (0,0,1,0) | 0^0^1^0 = 1 (Row 10, Col 00)
    // (0,1,1,0) | 0^1^1^0 = 0 (Row 10, Col 01)
    // (1,1,1,0) | 1^1^1^0 = 1 (Row 10, Col 11)
    // (1,0,1,0) | 1^0^1^0 = 0 (Row 10, Col 10)
    // All values match the Karnaugh map.
    assign out = a ^ b ^ c ^ d;
endmodule
