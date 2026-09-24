module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // ab = 00: K-map column is 0,1,1,1 => c OR d
    // Implemented as a 2-to-1 mux: select c, inputs d and 1
    assign mux_in[0] = c ? 1'b1 : d;

    // ab = 01: K-map column is all 0
    assign mux_in[1] = 1'b0;

    // ab = 11: K-map column is 0,0,1,0 => c AND d
    // Implemented as a 2-to-1 mux: select c, inputs 0 and d
    assign mux_in[2] = c ? d : 1'b0;

    // ab = 10: K-map column is 1,0,1,1 => c OR NOT d
    // Implemented as a 2-to-1 mux: select d, inputs 1 and c
    assign mux_in[3] = d ? c : 1'b1;

endmodule
