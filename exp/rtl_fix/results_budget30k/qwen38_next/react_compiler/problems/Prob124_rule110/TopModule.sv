module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    // Rule 110: index = {left, center, right}
    // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0  => 8'h6E
    localparam [7:0] RULE_110 = 8'b01101110;

    wire [511:0] next_q;

    // Zero padding: padded_q[i+1] = q[i], padded_q[0] = q[-1] = 0, padded_q[513] = q[512] = 0
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            // left = q[i+1], center = q[i], right = q[i-1]
            assign next_q[i] = RULE_110[{padded_q[i+2], padded_q[i+1], padded_q[i]}];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
