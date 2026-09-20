module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // The module implements Rule 90, a one-dimensional cellular automaton.
    // The next state of each cell is the XOR of its two current neighbors.
    // Boundaries q[-1] and q[512] are assumed to be zero.
    // The load input allows loading the initial state from the data input.

    always @(posedge clk) begin
        if (load) begin
            // Load the system state with the provided data.
            q <= data;
        end else begin
            // Compute the next state for each cell using Rule 90.
            // For a cell at index i, the neighbors are at indices i-1 and i+1.
            // (q << 1) at index i provides the value of q[i-1].
            // (q >> 1) at index i provides the value of q[i+1].
            // The boundary conditions (q[-1]=0 and q[512]=0) are naturally handled 
            // by the shift operations.
            q <= (q << 1) ^ (q >> 1);
        end
    end

endmodule
