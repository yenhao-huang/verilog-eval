module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

    localparam [1:0] IDLE = 2'd0,
                     GOT1 = 2'd1,
                     GOT2 = 2'd2,
                     GOT3 = 2'd3;

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            byte3 <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= GOT1;
                    end
                end
                GOT1: begin
                    byte2 <= in;
                    state <= GOT2;
                end
                GOT2: begin
                    byte3 <= in;
                    state <= GOT3;
                end
                GOT3: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= GOT1;
                    end else begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign done      = (state == GOT3);
    assign out_bytes = {byte1, byte2, byte3};

endmodule
