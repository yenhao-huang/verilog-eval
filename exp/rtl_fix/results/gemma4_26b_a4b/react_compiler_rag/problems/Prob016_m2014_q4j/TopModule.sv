module TopModule (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Internal carry wires, including the initial carry and the final carry-out
    wire [4:0] c;
    
    // Initial carry-in is 0
    assign c[0] = 1'b0;

    // Generate 4 full adders
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_gen
            // Sum bit calculation: S = A ^ B ^ Cin
            assign sum[i] = x[i] ^ y[i] ^ c[i];
            // Carry bit calculation: Cout = (A & B) | (A & Cin) | (B & Cin)
            assign c[i+1] = (x[i] & y[i]) | (x[i] & c[i]) | (y[i] & c[i]);
        end
    endgenerate

    // The 5th bit of the sum is the carry-out (overflow bit for unsigned addition)
    assign sum[4] = c[4];

endmodule
