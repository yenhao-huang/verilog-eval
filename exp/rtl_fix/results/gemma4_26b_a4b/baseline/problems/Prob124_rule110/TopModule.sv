module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // next_q stores the state of the system for the next time step
    reg [511:0] next_q;
    
    // Loop index and temporary variables for the cellular automaton logic
    integer i;
    reg L, C, R;

    // Sequential logic: Updates the state on the positive edge of the clock
    always @(posedge clk) begin
        if (load) begin
            // If load is high, the system state is initialized with the input data
            q <= data;
        end else begin
            // Otherwise, the system advances to the next state calculated in the combinational block
            q <= next_q;
        end
    end

    // Combinational logic: Calculates the next state for each cell based on Rule 110
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine the state of the left neighbor (L), current cell (C), and right neighbor (R)
            // Boundary conditions: q[-1] and q[512] are assumed to be 0
            L = (i == 0) ? 1'b0 : q[i-1];
            C = q[i];
            R = (i == 511) ? 1'b0 : q[i+1];

            // Implement Rule 110 truth table
            case ({L, C, R})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

endmodule
