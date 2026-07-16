module mux2 # (
    parameter width =32 
)
 (   
    input wire [width-1:0] in0,
    input wire [width-1:0] in1,
    input wire             sel,
    output wire[width-1:0] out
 );
 assign out =sel? in1:in0;
endmodule