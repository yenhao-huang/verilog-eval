module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // The circuit logic is as follows:
    // 1. A two-input XNOR is performed on in1 and in2.
    //    In Verilog, XNOR can be represented as ~(in1 ^ in2) or in1 ~^ in2.
    // 2. The result of the XNOR is then XORed with in3.
    //    In Verilog, XOR is represented by the ^ operator.

    assign out = ~(in1 ^ in2) ^ in3;

endmodule
