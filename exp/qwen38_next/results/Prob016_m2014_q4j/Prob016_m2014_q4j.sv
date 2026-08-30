module TopModule (
    input  logic [3:0] x,
    input  logic [3:0] y,
    output logic [4:0] sum
);

    logic [3:0] carry;

    assign sum[0]   = x[0] ^ y[0];
    assign carry[0] = x[0] & y[0];

    generate
        for (genvar i = 1; i < 4; i++) begin : full_adder
            assign sum[i]   = x[i] ^ y[i] ^ carry[i-1];
            assign carry[i] = (x[i] & y[i]) | (x[i] & carry[i-1]) | (y[i] & carry[i-1]);
        end
    endgenerate

    assign sum[4] = carry[3];

endmodule
