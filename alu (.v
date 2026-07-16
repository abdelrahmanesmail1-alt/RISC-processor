module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0]  alu_ctrl,
    output reg [31:0] result,
    output wire zero
);
    localparam alu_add =4'b0000;
    localparam alu_sub =4'b0001;
    localparam alu_and =4'b0010;
    localparam alu_or  =4'b0011;
    localparam alu_xor =4'b0100;
    localparam alu_sll =4'b0101;
    localparam alu_srl =4'b0110;
    localparam alu_sra =4'b0111;
    localparam alu_slt =4'b1000;
    localparam alu_sltu=4'b1001;
    always @(*) begin
        case (alu_ctrl)
            alu_add :result=a+b;
            alu_sub :result=a-b;
            alu_and :result=a&b;
            alu_or  :result=a|b;
            alu_xor :result=a^b;
            alu_sll :result=a<<b[4:0];
            alu_srl :result=a>>b[4:0];
            alu_sra :result=$signed (a)>>>b[4:0] ;
            alu_slt :result=($signed(a)<$signed(b))?32'b1:32'b0;
            alu_sltu:result= (a<b)?32'b1:32'b0;
            default: result=32'b0;
        endcase
    end
    assign zero =(result==32'b0);

endmodule