module TopModule (
    input  wire       clk,
    input  wire       reset,
    output wire [3:0] q
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 4'd1;           // synchronous active-high reset to 1
        else if (count == 4'd10)
            count <= 4'd1;           // wrap around after 10
        else
            count <= count + 4'd1;   // count 1..10
    end

    assign q = count;

endmodule
