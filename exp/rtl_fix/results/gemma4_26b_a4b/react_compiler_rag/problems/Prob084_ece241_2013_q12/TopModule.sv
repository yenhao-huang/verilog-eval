module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // The 8-bit shift register is implemented using a reg [7:0]
    // which will be synthesized into 8 D-type flip-flops.
    reg [7:0] Q;

    // The shift register logic:
    // S feeds the input of Q[0].
    // The enable input is synchronous active high and controls whether to shift.
    // When shifting, the bits move from Q[0] to Q[1], Q[1] to Q[2], ..., Q[6] to Q[7].
    // This means the first bit shifted in (S1) will eventually end up in Q[7],
    // which is the MSB of the register.
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // The random access part is implemented using a multiplexer.
    // The output Z is selected based on the 3-bit input {A, B, C}.
    // When ABC is 000, Z = Q[0].
    // When ABC is 001, Z = Q[1].
    // ... and so on.
    assign Z = Q[{A, B, C}];

endmodule
