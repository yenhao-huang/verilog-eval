module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // The reduction operators (&, |, ^) perform the operation 
    // across all bits of the vector, resulting in a single bit.
    
    // (1) out_and: output of a 100-input AND gate
    assign out_and = &in;

    // (2) out_or: output of a 100-input OR gate
    assign out_or  = |in;

    // (3) out_xor: output of a 100-input XOR gate
    assign out_xor = ^in;

endmodule
