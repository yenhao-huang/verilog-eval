module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // The 8-bit shift register consisting of 8 D-type flip-flops.
    // We label the outputs from Q[0] to Q[7].
    reg [7:0] Q;

    // Sequential logic for the shift register.
    // The enable input is synchronous active high and controls whether to shift.
    // The shift register input S feeds the input of Q[0].
    // When shifting, Q[0] gets S, Q[1] gets the old Q[0], Q[2] gets the old Q[1], etc.
    // This is implemented using the concatenation {Q[6:0], S}.
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // The circuit uses a multiplexer to realize a 3-input logic function.
    // The inputs A, B, and C act as the selection lines for the 8-to-1 multiplexer.
    // When ABC is 000, Z = Q[0].
    // When ABC is 001, Z = Q[1].
    // ...
    // When ABC is 111, Z = Q[7].
    assign Z = Q[{A, B, C}];

endmodule
