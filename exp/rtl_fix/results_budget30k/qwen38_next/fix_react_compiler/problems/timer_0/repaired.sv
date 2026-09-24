module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);

    reg [9:0] counter = 10'd0;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;          // load can happen any time, even mid-count
        end
        else if (counter != 10'd0) begin
            counter <= counter - 10'd1;  // decrement, and stop (saturate) at 0
        end
    end

    // tc is a wire: drive it with a continuous assignment, not a procedural one
    assign tc = (counter == 10'd0);

endmodule
