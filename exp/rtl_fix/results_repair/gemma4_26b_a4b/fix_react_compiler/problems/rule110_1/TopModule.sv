module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Rule 110 logic
            // L | C | R | Next
            // 1 | 1 | 1 | 0
            // 1 | 1 | 0 | 1
            // 1 | 0 | 1 | 1
            // 1 | 0 | 0 | 0
            // 0 | 1 | 1 | 1
            // 0 | 1 | 0 | 1
            // 0 | 0 | 1 | 1
            // 0 | 0 | 0 | 0
            
            // Define L, C, R using bitwise operations
            // L = {1'b0, q[511:1]}
            // C = q
            // R = {q[510:0], 1'b0}
            
            // The next state of q is determined by the 5 rules that result in 1:
            // (L=1, C=1, R=0) -> 1
            // (L=1, C=0, R=1) -> 1
            // (L=0, C=1, R=1) -> 1
            // (L=0, C=1, R=0) -> 1
            // (L=0, C=0, R=1) -> 1
            
            q <= ({1'b0, q[511:1]} & q & ~{q[510:0], 1'b0}) |
                 ({1'b0, q[511:1]} & ~q & {q[510:0], 1'b0}) |
                 (~{1'b0, q[511:1]} & q & {q[510:0], 1'b0}) |
                 (~{1'b0, q[511:1]} & q & ~{q[510:0], 1'b0}) |
                 (~{1'b0, q[511:1]} & ~q & {q[510:0], 1'b0});
        end
    end
endmodule
