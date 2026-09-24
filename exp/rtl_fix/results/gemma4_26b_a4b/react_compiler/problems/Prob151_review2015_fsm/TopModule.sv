```verilog
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State definitions
    parameter S_SEARCH = 2'b00;
    parameter S_SHIFT  = 2'b01;
    parameter S_COUNT  = 2'b10;
    parameter S_ACK    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_cnt;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous active-high reset
            state <= S_SEARCH;
            pattern_reg <= 4'b0000;
            shift_cnt <= 2'
