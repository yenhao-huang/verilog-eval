module top_module (
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // The problem asks for a 256-to-1 multiplexer where each selection 
    // picks a 4-bit chunk from a 1024-bit input.
    // The index-based part-select operator (base +: width) is the most 
    // efficient way to implement this.
    // For sel=0, it selects in[0*4 +: 4] -> in[3:0]
    // For sel=1, it selects in[1*4 +: 4] -> in[7:4]
    // For sel=2, it selects in[2*4 +: 4] -> in[11:8]
    
    assign out = in[sel*4 +: 4];

endmodule
