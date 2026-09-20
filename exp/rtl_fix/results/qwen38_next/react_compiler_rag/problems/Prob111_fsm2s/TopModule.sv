module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output wire out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;               // synchronous active-high reset
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;   // j=1 -> ON, j=0 -> OFF
                ON:  state <= k ? OFF : ON;   // k=1 -> OFF, k=0 -> ON
                default: state <= OFF;
            endcase
        end
    end

    // Moore output: depends only on state
    assign out = (state == ON);

endmodule
