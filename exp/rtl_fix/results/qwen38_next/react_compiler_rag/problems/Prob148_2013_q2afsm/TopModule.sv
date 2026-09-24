module TopModule (
  input        clk,
  input        resetn,
  input  [2:0] r,
  output [2:0] g
);

  parameter [1:0] A = 2'd0,
                  B = 2'd1,
                  C = 2'd2,
                  D = 2'd3;

  reg [1:0] state, nextstate;

  // state flip-flops (active-low synchronous reset)
  always @(posedge clk) begin
    if (!resetn)
      state <= A;
    else
      state <= nextstate;
  end

  // state table (next-state logic)
  always @(*) begin
    case (state)
      A: begin
        if (r[0])
          nextstate = B;
        else if (r[1])
          nextstate = C;
        else if (r[2])
          nextstate = D;
        else
          nextstate = A;
      end
      B: nextstate = r[0] ? B : A;
      C: nextstate = r[1] ? C : A;
      D: nextstate = r[2] ? D : A;
      default: nextstate = A;
    endcase
  end

  // FSM outputs (Moore)
  assign g = (state == B) ? 3'b001 :
             (state == C) ? 3'b010 :
             (state == D) ? 3'b100 : 3'b000;

endmodule
