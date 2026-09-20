module TopModule (
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] count;
    reg [9:0] d;

    always @(*) begin
        if (load)
            d = data;                    // load new countdown value
        else if (count == 10'd0)
            d = 10'd0;                   // stay at 0 until reloaded
        else
            d = count - 10'd1;           // decrement
    end

    always @(posedge clk) begin
        count <= d;                      // single D flip-flop (10-bit register)
    end

    assign tc = (count == 10'd0);        // terminal count

endmodule
