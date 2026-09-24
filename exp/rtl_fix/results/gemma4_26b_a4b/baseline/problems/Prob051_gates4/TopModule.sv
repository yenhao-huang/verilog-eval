module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // The reduction operators (&, |, ^) perform the operation 
    // across all bits of the single operand.
    
    // out_and: Performs in[3] & in[2] & in[1] & in[0]
    assign out_and = &in;
    
    // out_or: Performs in[3] | in[2] | in[1] | in[0]
    assign out_or  = |in;
    
    // out_xor: Performs in[3] ^ in[2] ^ in[1] ^ in[0]
    assign out_xor = ^in;

endmodule
