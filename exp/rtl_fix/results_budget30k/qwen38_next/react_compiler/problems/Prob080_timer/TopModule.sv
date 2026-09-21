module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] count = 10'd0;

    always @(posedge clk) begin
        if (load) begin
            count <= data;              // (1) load any time, even while counting
        end else if (count != 10'd0) begin
            count <= count - 10'd1;     // (2) decrement, stop at 0
        end
    end

    assign tc = (count == 10'd0);       // terminal count

endmodule
