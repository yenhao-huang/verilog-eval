module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State register, initialized to state 000 for simulation convenience
    reg [2:0] y = 3'b000;
    reg [2:0] y_next;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= y_next;
    end

    // Next-state logic
    always @(*) begin
        case (y)
            3'b000: y_next = x ? 3'b001 : 3'b000;
            3'b001: y_next = x ? 3'b100 : 3'b001;
            3'b010: y_next = x ? 3'b001 : 3'b010;
            3'b011: y_next = x ? 3'b010 : 3'b001;
            3'b100: y_next = x ? 3'b100 : 3'b011;
            default: y_next = 3'b000;
        endcase
    end

    // Moore output: z is high for states 011 and 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule
