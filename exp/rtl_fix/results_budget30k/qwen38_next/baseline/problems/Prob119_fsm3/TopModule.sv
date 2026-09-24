module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam [1:0] A = 2'd0;
    localparam [1:0] B = 2'd1;
    localparam [1:0] C = 2'd2;
    localparam [1:0] D = 2'd3;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

    assign out = (state == D);

endmodule
