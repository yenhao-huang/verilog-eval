module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

    // The module implements a 6-to-1 multiplexer using combinational logic.
    // A case statement is used to select the appropriate data input based on the 'sel' signal.
    // If 'sel' is greater than 5, the 'default' case ensures the output is 0.
    always @(*) begin
        case (sel)
            3'd0: out = data0;
            3'd1: out = data1;
            3'd2: out = data2;
            3'd3: out = data3;
            3'd4: out = data4;
            3'd5: out = data5;
            default: out = 4'b0000;
        endcase
    end

endmodule
