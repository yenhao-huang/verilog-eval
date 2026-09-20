module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State register
    reg [2:0] y;
    // Next state register
    reg [2:0] next_y;

    // Sequential logic: State transition
    // Resets to 000 synchronously on the rising edge of clk
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000;
        end else begin
            y <= next_y;
        end
    end

    // Combinational logic: Next state logic
    // Determines next_y based on the current state y and input x
    always @(*) begin
        case (y)
            3'b000: begin
                if (x == 1'b1)
                    next_y = 3'b001;
                else
                    next_y = 3'b000;
            end
            3'b001: begin
                if (x == 1'b1)
                    next_y = 3'b100;
                else
                    next_y = 3'b001;
            end
            3'b010: begin
                if (x == 1'b1)
                    next_y = 3'b001;
                else
                    next_y = 3'b010;
            end
            3'b011: begin
                if (x == 1'b1)
                    next_y = 3'b010;
                else
                    next_y = 3'b001;
            end
            3'b100: begin
                if (x == 1'b1)
                    next_y = 3'b100;
                else
                    next_y = 3'b011;
            end
            default: begin
                next_y = 3'b000;
            end
        endcase
    end

    // Combinational logic: Output logic
    // Based on the provided table, z is 1 when the present state is 011 or 100
    always @(*) begin
        case (y)
            3'b011:  z = 1'b1;
            3'b100:  z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule
