module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    integer i;
    reg [7:0] count;

    always @(*) begin
        count = 8'd0;
        for (i = 0; i < 255; i = i + 1) begin
            if (in[i])
                count = count + 8'd1;
        end
    end

    assign out = count;

endmodule
