module TopModule (
    input  clk,
    input  load,
    input  [9:0] data,
    output tc
);

    reg [9:0] count = 10'd0;

    always @(posedge clk) begin
        if (load) begin
            count <= data;
        end else if (count != 10'd0) begin
            count <= count - 10'd1;
        end
        // If load = 0 and count = 0, stay at 0.
    end

    assign tc = (count == 10'd0);

endmodule
