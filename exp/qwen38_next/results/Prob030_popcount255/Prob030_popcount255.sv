module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    logic [7:0] sum;

    always_comb begin
        sum = 8'd0;
        for (int i = 0; i < 255; i++) begin
            sum = sum + {7'b0, in[i]};
        end
    end

    assign out = sum;

endmodule
