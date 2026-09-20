module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A:       state <= x ? B : A;
                B:       state <= B;
                default: state <= A;
            endcase
        end
    end

    // Mealy output:
    //   In A: x=0 -> z=0, x=1 -> z=1
    //   In B: x=0 -> z=1, x=1 -> z=0
    assign z = (state == A) ? x : ~x;

endmodule
