module top_module (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map columns (ab = 00, 01, 11, 10) as functions of c,d
    wire mux0 = c ? 1'b1 : d;   // ab = 00 -> c + d
    wire mux1 = 1'b0;           // ab = 01 -> 0 (no 2:1 mux needed)
    wire mux2 = c ? d : 1'b0;   // ab = 11 -> c * d
    wire mux3 = d ? c : 1'b1;   // ab = 10 -> c + d'

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule
