module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar r, c;
    generate
        for (r = 0; r < 16; r = r + 1) begin : gen_row
            for (c = 0; c < 16; c = c + 1) begin : gen_col
                localparam [31:0] up    = (r == 0)  ? 15 : r - 1;
                localparam [31:0] down  = (r == 15) ? 0  : r + 1;
                localparam [31:0] left  = (c == 0)  ? 15 : c - 1;
                localparam [31:0] right = (c == 15) ? 0  : c + 1;
                localparam [31:0] idx   = r * 16 + c;

                wire [3:0] alive_neighbors;

                // Count the 8 neighbours on the wrapping 16x16 toroid
                assign alive_neighbors =
                    {3'b0, q[up    * 16 + left]}  +
                    {3'b0, q[up    * 16 + c]}     +
                    {3'b0, q[up    * 16 + right]} +
                    {3'b0, q[r     * 16 + left]}  +
                    {3'b0, q[r     * 16 + right]} +
                    {3'b0, q[down  * 16 + left]}  +
                    {3'b0, q[down  * 16 + c]}     +
                    {3'b0, q[down  * 16 + right]};

                // Life: 3 neighbours -> born; 2 neighbours -> survive; else die
                assign next_q[idx] = (alive_neighbors == 4'd3) ||
                                     (q[idx] && (alive_neighbors == 4'd2));
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;      // synchronous active-high load of initial state
        else
            q <= next_q;    // advance one timestep
    end

endmodule
