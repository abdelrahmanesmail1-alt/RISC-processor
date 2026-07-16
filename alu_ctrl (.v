module alu_ctrl (
      input wire [1:0] alu_op,
    input wire [2:0] function3,
    input wire       function7_5,
    input wire [6:0] opcode,
    output reg [3:0]alu_control
);
localparam op_rtype=7'b0110011;
wire is_rtype=(opcode==op_rtype);
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
        case (alu_op)
            2'b00:alu_control=alu_add;
            2'b10:begin
                case (function3)
                     3'b000: alu_control = (function7_5&&is_rtype) ? alu_sub : alu_add; 
                    3'b001: alu_control= alu_sll;
                    3'b010: alu_control = alu_slt;
                    3'b011: alu_control = alu_sltu;
                    3'b100: alu_control = alu_xor;
                    3'b101: alu_control = function7_5? alu_sra : alu_srl; 
                    3'b110: alu_control = alu_or;
                    3'b111: alu_control = alu_and;
                     
                    default:alu_control=alu_add ;
                endcase
            end
            default: alu_control=alu_add;
        endcase
    end
endmodule