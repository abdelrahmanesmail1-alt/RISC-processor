module imm_generator (
    input wire [31:0] instruction,
    output reg [31:0] imm_ext
);
    wire [6:0]opcode =instruction[6:0];
    localparam op_imm =7'b0010011 ;
     localparam  op=7'b0110011 ;
      localparam  load=7'b0000011 ;
       localparam  store=7'b0100011 ;
        localparam  branch=7'b1100011 ;
         localparam  jal=7'b1101111 ;
          localparam  jalr=7'b1100111 ;
           localparam  lui=7'b0110111 ;
            localparam  auipc=7'b0010111 ;
            always@(*)begin
                case (opcode)
                    op_imm,load,jalr:imm_ext={{20{instruction[31]}},instruction[31:20]};
                    
                    store:
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                          branch:
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7],
                           instruction[30:25], instruction[11:8], 1'b0};

                           lui,auipc:
                           imm_ext = {instruction[31:12], 12'b0};
                          
                           jal: imm_ext = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                           instruction[20], instruction[30:21], 1'b0};
                    default: imm_ext=32'b0;
                endcase
            end
endmodule