module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    wire [3:0] s;
    wire [4:0] carry;

    // Carry-in for the least significant bit
    assign carry[0] = 1'b0;

    genvar i;
    generate
        // Four full adders, one for each bit
        for (i = 0; i < 4; i = i + 1) begin : full_adder
            assign s[i] = x[i] ^ y[i] ^ carry[i];
            assign carry[i + 1] = (x[i] & y[i]) | (carry[i] & (x[i] ^ y[i]));
        end
    endgenerate

    // Overflow bit is the final carry-out
    assign sum = {carry[4], s};

endmodule
