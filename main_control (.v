module main_control (
     input wire  [6:0] opcode,
    output reg         regwrite,
    output reg         memwrite,
    output reg         memread,
    output reg   [1:0] alusrca,
    output reg         alusrcb,
    output reg   [1:0] aluop,  
    output reg   [1:0] memtoreg,
    output reg         branch,
    output reg         jump

);
    localparam OP_IMM = 7'b0010011;
    localparam OP     = 7'b0110011;
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam BRANCH = 7'b1100011;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;
    localparam LUI    = 7'b0110111;
    localparam AUIPC  = 7'b0010111;
    always @(*) begin
        regwrite=1'b0 ;
        memwrite=1'b0 ;
        memread =1'b0 ;
        alusrca =2'b00;
        alusrcb =1'b0 ;
        aluop   =2'b00;
        memtoreg=2'b00;
        branch  =1'b0 ;
        jump    =1'b0 ;
        case (opcode)
            OP:begin
                    regwrite=1'b1 ;
                    alusrca =2'b00;
                    alusrcb =1'b0 ;
                    aluop   =2'b10;
                    memtoreg=2'b00;
            end 
            OP_IMM:begin
                   regwrite=1'b1 ;
                    alusrca =2'b00;
                    alusrcb =1'b1 ;
                    aluop   =2'b10;
                    memtoreg=2'b00;
            end
            LOAD:begin
                   regwrite=1'b1 ;
                    alusrca =2'b00;
                    alusrcb =1'b1 ;
                    aluop   =2'b00;
                    memtoreg=2'b01;
                    memread =1'b1 ;
            end
            STORE:begin
                   memwrite=1'b1 ;
                    alusrca =2'b00;
                    alusrcb =1'b1 ;
                    aluop   =2'b00;
                    
            end
            BRANCH:begin
                    alusrca =2'b00;
                    alusrcb =1'b0 ;
                    branch  =1'b1;
            end
            JAL:begin
                regwrite =1'b1 ;
                memtoreg=2'b10 ;
                jump    =1'b1  ;
            end
            JALR:begin
                   regwrite=1'b1 ;
                    alusrca =2'b00;
                    alusrcb =1'b1 ;
                    aluop   =2'b00;
                    jump    =1'b1 ;
                    memtoreg=2'b10;
            end
            LUI:begin
                   regwrite=1'b1 ;
                    alusrca =2'b10;
                    alusrcb =1'b1 ;
                    aluop   =2'b00;
                    memtoreg=2'b00;
            end
            AUIPC:begin
                   regwrite=1'b1 ;
                    alusrca =2'b01;
                    alusrcb =1'b1 ;
                    aluop   =2'b00;
                    memtoreg=2'b00;
            end
            default: begin
                
            end
        endcase

    end
    
endmodule