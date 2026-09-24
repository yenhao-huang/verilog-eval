module TopModule (
    input        clk,
    input        load,
    input  [255:0] data,
    output [255:0] q
);

    reg [255:0] q;
    reg [255:0] next_q;
    integer r, c;
    integer count;

    // Combinational next-state computation (Conway's Game of Life on a 16x16 torus)
    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                count = count + q[((r + 15) % 16) * 16 + ((c + 15) % 16)]; // up-left
                count = count + q[((r + 15) % 16) * 16 + c];               // up
                count = count + q[((r + 15) % 16) * 16 + ((c + 1) % 16)];  // up-right
                count = count + q[r * 16 + ((c + 15) % 16)];               // left
                count = count + q[r * 16 + ((c + 1) % 16)];                // right
                count = count + q[((r + 1) % 16) * 16 + ((c + 15) % 16)];  // down-left
                count = count + q[((r + 1) % 16) * 16 + c];                // down
                count = count + q[((r + 1) % 16) * 16 + ((c + 1) % 16)];   // down-right

                if (count == 3)
                    next_q[r * 16 + c] = 1'b1;
                else if (count == 2)
                    next_q[r * 16 + c] = q[r * 16 + c];
                else
                    next_q[r * 16 + c] = 1'b0;
            end
        end
    end

    // Sequential state update with synchronous active-high load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
