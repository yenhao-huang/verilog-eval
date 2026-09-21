module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;              // load new countdown value any time
        end
        else if (counter != 0) begin
            counter <= counter - 1'b1;    // decrement, stop at 0
        end
    end

    // tc is a wire -> drive it with a continuous assignment, not a procedural one
    assign tc = (counter == 0);

endmodule
