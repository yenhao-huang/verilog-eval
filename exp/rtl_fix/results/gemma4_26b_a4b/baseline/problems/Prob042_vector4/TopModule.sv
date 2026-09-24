module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // To sign-extend an 8-bit number to 32 bits, we need to 
    // replicate the sign bit (the most significant bit, in[7]) 
    // 24 times and concatenate it with the original 8-bit input.
    // 24 (replicated bits) + 8 (original bits) = 32 bits total.
    
    assign out = {{24{in[7]}}, in};

endmodule
