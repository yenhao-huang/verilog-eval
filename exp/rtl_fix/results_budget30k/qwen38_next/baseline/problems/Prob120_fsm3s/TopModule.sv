module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    localparam [1:0] A = 2'd0,
                     B = 2'd1,
                     C = 2'd2,
                     D = 2'd3;

    reg [1:0] state;

    // Synchronous active-high reset, positive-edge triggered state update
    always @(posedge clk) begin
        if (reset) begin
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

    // Moore output: depends only on current state
    assign out = (state == D);

endmodule
