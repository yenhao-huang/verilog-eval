module TopModule (
    input            clk,
    input            load,
    input  [511:0]   data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Pad q with zeros to implement boundaries:
    // q[-1] = 0 and q[512] = 0
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q, 1'b0};

    // Rule 110 next-state function
    function rule110;
        input l, c, r;
        begin
            case ({l, c, r})
                3'b110,
                3'b101,
                3'b011,
                3'b010,
                3'b001: rule110 = 1'b1;
                default: rule110 = 1'b0;
            endcase
        end
    endfunction

    // Compute next state for all 512 cells
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            assign next_q[i] = rule110(q_ext[i + 2], q_ext[i + 1], q_ext[i]);
        end
    endgenerate

    // Synchronous load and state update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
