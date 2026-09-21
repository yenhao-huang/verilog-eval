module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

    always @* begin
        if (state == D) begin
            out = 1'b1;
        end
        else begin
            out = 1'b0;
        end
    end

endmodule
