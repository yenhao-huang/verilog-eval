module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // One-hot encoding:
    //   y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    //
    // Y1 is the next-state input for flip-flop y[1] (state B).
    // The only transition into B is A --w=1--> B
    assign Y1 = y[0] & w;

    // Y3 is the next-state input for flip-flop y[3] (state D).
    // Transitions into D are: B --0--> D, C --0--> D, E --0--> D, F --0--> D
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
