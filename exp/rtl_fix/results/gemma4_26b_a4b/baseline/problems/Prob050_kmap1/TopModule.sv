module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    /*
    Karnaugh Map Analysis:
    
              a
       bc   0   1
       00 | 0 | 1 |
       01 | 1 | 1 |
       11 | 1 | 1 |
       10 | 1 | 1 |

    Minterms where out = 1:
    - a=0, b=0, c=1  => !a & !b & c
    - a=0, b=0, c=0  => (0)
    - a=0, b=1, c=1  => !a & b & c
    - a=0, b=1, c=0  => !a & b & !c
    - a=1, b=0, c=0  => a & !b & !c
    - a=1, b=0, c=1  => a & !b & c
    - a=1, b=1, c=1  => a & b & c
    - a=1, b=1, c=0  => a & b & !c

    Simplification:
    - The entire column where a=1 is filled with 1s. This gives the term: 'a'
    - In the column where a=0, the cells where b=1 or c=1 are filled with 1s. 
      This covers (b=1, c=0), (b=1, c=1), and (b=0, c=1).
      This gives the term: 'b | c'
    
    Combining these: out = a | b | c
    
    Verification:
    - If a=1, out=1 (Matches column a=1)
    - If a=0:
        - bc=00: 0|0|0 = 0 (Matches)
        - bc=01: 0|0|1 = 1 (Matches)
        - bc=11: 0|1|1 = 1 (Matches)
        - bc=10: 0|1|0 = 1 (Matches)
    */

    assign out = a | b | c;

endmodule
