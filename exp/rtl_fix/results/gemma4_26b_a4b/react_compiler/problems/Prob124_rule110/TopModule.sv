module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] q_reg;

    // Rule 110 transition function
    function [0:0] rule110(input L, input C, input R);
        case ({L, C, R})
            3'b111: rule110 = 1'b0;
            3'b110: rule110 = 1'b1;
            3'b101: rule110 = 1'b1;
            3'b100: rule110 = 1'b0;
            3'b011: rule110 = 1'b1;
            3'b010: rule110 = 1'b1;
            3'b001: rule110 = 1'b1;
            3'b000: rule110 = 1'b0;
            default: rule110 = 1'b0;
        endcase
    endfunction

    wire [511:0] q_next;

    // Boundary conditions: q[-1] = 0 and q[512] = 0
    // Cell 0: Left is q[1], Center is q[0], Right is q[-1]=0
    assign q_next[0] = rule110(q_reg[1], q_reg[0], 1'b0);
    // Cell 511: Left is q[512]=0, Center is q[511], Right is q[510]
    assign q_next[511] = rule110(1'b0, q_reg[511], q_reg[510]);

    // Internal cells
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule_gen
            assign q_next[i] = rule110(q_reg[i+1], q_reg[i], q_reg[i-1]);
        end
    endgenerate

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= q_next;
        end
    end

    assign q = q_reg;

endmodule
