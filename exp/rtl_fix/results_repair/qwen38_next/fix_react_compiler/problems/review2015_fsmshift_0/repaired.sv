module top_module(
	input clk,
	input reset,
	output shift_ena);

    // B0 -> B1 -> B2 -> B3 -> Done
    // B0: first shift cycle
    // B1: second shift cycle
    // B2: third shift cycle
    // B3: fourth shift cycle
    // Done: no more shifting
    reg [2:0] state = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= 3'b001;
                3'b001: state <= 3'b010;
                3'b010: state <= 3'b011;
                3'b011: state <= 3'b100;
                default: state <= 3'b100;
            endcase
        end
    end

    assign shift_ena = (state == 3'b000) ||
                       (state == 3'b001) ||
                       (state == 3'b010) ||
                       (state == 3'b011);

endmodule
