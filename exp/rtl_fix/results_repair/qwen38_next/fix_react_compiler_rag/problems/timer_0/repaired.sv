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
        end else if (counter != 10'd0) begin
            counter <= counter - 10'd1;   // decrement, saturate at 0
        end
    end

    // tc is a wire (default output type) -> drive it with a continuous assignment
    assign tc = (counter == 10'd0);

endmodule
