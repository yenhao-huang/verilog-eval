module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    localparam [2:0] IDLE    = 3'd0; // no bits matched
    localparam [2:0] GOT_1   = 3'd1; // matched 1
    localparam [2:0] GOT_11  = 3'd2; // matched 11
    localparam [2:0] GOT_110 = 3'd3; // matched 110
    localparam [2:0] FOUND   = 3'd4; // matched 1101

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:    state <= data ? GOT_1   : IDLE;
                GOT_1:   state <= data ? GOT_11  : IDLE;
                GOT_11:  state <= data ? GOT_11  : GOT_110;
                GOT_110: state <= data ? FOUND   : IDLE;
                FOUND:   state <= FOUND;
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = (state == FOUND);

endmodule
