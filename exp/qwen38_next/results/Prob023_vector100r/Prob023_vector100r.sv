module TopModule (
    input  logic [99:0] in,
    output logic [99:0] out
);

    for (genvar i = 0; i < 100; i++) begin : gen_reverse
        assign out[i] = in[99 - i];
    end

endmodule
