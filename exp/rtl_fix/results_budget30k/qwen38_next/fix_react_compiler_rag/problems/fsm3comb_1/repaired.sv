module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

    // State transition (combinational) logic
    always_comb begin
        case (state)
            2'b00:   next_state = in ? 2'b01 : 2'b00;   // A -> B / A
            2'b01:   next_state = in ? 2'b01 : 2'b10;   // B -> B / C
            2'b10:   next_state = in ? 2'b11 : 2'b00;   // C -> D / A
            2'b11:   next_state = in ? 2'b01 : 2'b10;   // D -> B / C
            default: next_state = 2'b00;
        endcase
    end

    // Moore output logic: continuous assignment because 'out' is a wire
    assign out = (state == 2'b11);

endmodule
