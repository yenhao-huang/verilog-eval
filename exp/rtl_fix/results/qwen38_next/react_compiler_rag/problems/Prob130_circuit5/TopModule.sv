module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    reg [3:0] q_r;

    always @(*) begin
        case (c)
            4'd0:    q_r = b;
            4'd1:    q_r = e;
            4'd2:    q_r = a;
            4'd3:    q_r = d;
            default: q_r = 4'hf;
        endcase
    end

    assign q = q_r;

endmodule
