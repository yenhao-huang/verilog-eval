module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] count;

    initial count = 10'd0;

    always @(posedge clk) begin
        if (load) begin
            count <= data;              // load new timeout value
        end else if (count != 10'd0) begin
            count <= count - 10'd1;     // decrement until 0, then hold
        end
    end

    assign tc = (count == 10'd0);       // terminal count

endmodule
