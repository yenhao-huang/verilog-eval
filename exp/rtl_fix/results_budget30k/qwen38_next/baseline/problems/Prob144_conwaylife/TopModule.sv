module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer r, c, idx;
    integer n;

    // Optional simulation initialization.
    initial begin
        q = 256'd0;
        next_q = 256'd0;
    end

    // Synchronous state update.
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    // Combinational next-state calculation.
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                idx = r * 16 + c;

                // Count the 8 toroidal neighbors.
                n = q[(((r + 15) % 16) * 16) + ((c + 15) % 16)] +
                    q[(((r + 15) % 16) * 16) + c] +
                    q[(((r + 15) % 16) * 16) + ((c + 1) % 16)] +
                    q[(r * 16) + ((c + 15) % 16)] +
                    q[(r * 16) + ((c + 1) % 16)] +
                    q[(((r + 1) % 16) * 16) + ((c + 15) % 16)] +
                    q[(((r + 1) % 16) * 16) + c] +
                    q[(((r + 1) % 16) * 16) + ((c + 1) % 16)];

                // Game of Life rules.
                next_q[idx] = (n == 3) || (q[idx] && (n == 2));
            end
        end
    end

endmodule
