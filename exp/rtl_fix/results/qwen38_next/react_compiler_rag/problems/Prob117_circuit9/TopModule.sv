module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

  // From the waveform:
  //  - When a = 1, q is loaded with 4 (3'b100) on every clock edge.
  //  - When a = 0, q counts up: 4 -> 5 -> 6 -> 0 -> 1 -> ...
  //    (i.e. it wraps from 6 back to 0 instead of going to 7).
  always @(posedge clk) begin
    if (a)
      q <= 3'b100;              // load 4
    else if (q == 3'b110)
      q <= 3'b000;              // wrap 6 -> 0
    else
      q <= q + 3'b001;          // normal increment
  end

endmodule
