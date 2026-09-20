module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // next_q will hold the state of the grid for the next clock cycle
    reg [255:0] next_q;

    // Combinational block to calculate the next state of the grid
    always @(*) begin
        // Local variables for the loops and calculations
        integer r, c, idx, count;
        integer r_up, r_down, c_left, c_right;
        
        // Initialize next_q to 0 to avoid latches and provide a default state
        next_q = 256'b0;

        // Iterate through every cell in the 16x16 grid
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Calculate the current cell's index in the 256-bit vector
                idx = r * 16 + c;

                // Calculate neighbor indices with toroidal (wrap-around) logic
                // r_up/r_down handles the vertical wrap-around
                // c_left/c_right handles the horizontal wrap-around
                r_up    = (r == 0)    ? 15 : r - 1;
                r_down  = (r == 15)   ? 0  : r + 1;
                c_left  = (c == 0)    ? 15 : c - 1;
                c_right = (c == 15)   ? 0  : c + 1;

                // Count the number of living neighbors (1s) around the current cell
                // The 8 neighbors are calculated using the toroidal indices
                count = q[r_up * 16 + c_left] +
                        q[r_up * 16 + c] +
                        q[r_up * 16 + c_right] +
                        q[r * 16 + c_left] +
                        q[r * 16 + c_right] +
                        q[r_down * 16 + c_left] +
                        q[r_down * 16 + c] +
                        q[r_down * 16 + c_right];

                // Apply the Game of Life rules:
                // (1) 0-1 neighbour: Cell becomes 0.
                // (2) 2 neighbours: Cell state does not change.
                // (3) 3 neighbours: Cell becomes 1.
                // (4) 4+ neighbours: Cell becomes 0.
                if (count == 3) begin
                    next_q[idx] = 1'b1;
                end else if (count == 2) begin
                    next_q[idx] = q[idx];
                end else begin
                    next_q[idx] = 1'b0;
                end
            end
        end
    end

    // Sequential block to update the state on the positive edge of the clock
    always @(posedge clk) begin
        if (load) begin
            // Synchronous load: update q with the provided data
            q <= data;
        end else begin
            // Update q with the next state calculated in the combinational block
            q <= next_q;
        end
    end

endmodule
