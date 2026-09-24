module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Assign the entire 3-bit vector to the output outv
    assign outv = vec;

    // Split the 3-bit vector into individual 1-bit outputs
    // o0 connects to position 0, o1 to position 1, and o2 to position 2
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule
