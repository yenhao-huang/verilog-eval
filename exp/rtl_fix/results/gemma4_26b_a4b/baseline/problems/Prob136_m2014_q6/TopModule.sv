module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding using localparam
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // State registers
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Sequential logic: State transition on positive edge of clock
    // Using asynchronous reset as per standard Verilog practice for "positive edge triggered" reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic: Next state logic based on current state and input w
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // Combinational logic: Output z based on the current state
    // Based on the description: A, B, C, D have output 0; E, F have output 1
    assign z = (current_state == E || current_state == F);

endmodule
