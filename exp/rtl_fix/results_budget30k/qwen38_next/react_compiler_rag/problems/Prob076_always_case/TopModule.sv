module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

    reg [3:0] out_reg;

    always @(*) begin
        case (sel)
            3'd0:    out_reg = data0;
            3'd1:    out_reg = data1;
            3'd2:    out_reg = data2;
            3'd3:    out_reg = data3;
            3'd4:    out_reg = data4;
            3'd5:    out_reg = data5;
            default: out_reg = 4'b0;
        endcase
    end

    assign out = out_reg;

endmodule
