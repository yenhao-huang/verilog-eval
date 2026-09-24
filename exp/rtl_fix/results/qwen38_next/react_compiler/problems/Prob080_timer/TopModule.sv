module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] count;

    always @(posedge clk) begin
        if (load) begin
            count <= data;
        end else if (count != 10'd0) begin
            count <= count - 10'd1;
        end
    end

    assign tc = (count == 10'd0);

endmodule
