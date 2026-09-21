module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    localparam [1:0] S0 = 2'd0,  // No useful prefix detected
                     S1 = 2'd1,  // Detected "1"
                     S2 = 2'd2;  // Detected "10"

    reg [1:0] state;

    // Negative-edge triggered asynchronous reset, active-low aresetn
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S1 : S2;
                S2: state <= x ? S1 : S0;
                default: state <= S0;
            endcase
        end
    end

    // Mealy output: assert z when current state is "10" and input x is 1
    assign z = (state == S2) && x;

endmodule
