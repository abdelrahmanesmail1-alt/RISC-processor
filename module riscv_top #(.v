module riscv_top #(
    parameter IMEM_WORDS = 256,
    parameter DMEM_WORDS = 256
) (
    input wire clock,
    input wire rst
);

    
    // Program Counter
   
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch_target; 
    wire [31:0] pc_jalr_target;     

    program_counter u_pc (
        .clock      (clock),
        .rst        (rst),
        .pc_next    (pc_next),
        .pc_current (pc_current)
    );

    assign pc_plus4         = pc_current + 32'd4;
    assign pc_branch_target = pc_current + imm_ext;
    assign pc_jalr_target   = {alu_result[31:1], 1'b0};

   
    // Instruction Memory
    wire [31:0] instruction;

    instruction_memory #(.MEM_WORDS(IMEM_WORDS)) u_imem (
        .addr        (pc_current),
        .instruction (instruction)
    );

    // Instruction field decode
   
    wire [6:0] opcode      = instruction[6:0];
    wire [4:0] rd_addr     = instruction[11:7];
    wire [2:0] funct3      = instruction[14:12];
    wire [4:0] rs1_addr    = instruction[19:15];
    wire [4:0] rs2_addr    = instruction[24:20];
    wire       funct7_5    = instruction[30];
    wire       is_jalr     = (opcode == 7'b1100111);
    // Main Control
   
    wire        regwrite, memwrite, memread, alusrcb, branch, jump;
    wire [1:0]  alusrca, aluop, memtoreg;

    main_control u_ctrl (
        .opcode   (opcode),
        .regwrite (regwrite),
        .memwrite (memwrite),
        .memread  (memread),
        .alusrca  (alusrca),
        .alusrcb  (alusrcb),
        .aluop    (aluop),
        .memtoreg (memtoreg),
        .branch   (branch),
        .jump     (jump)
    );

  
    // Register File

    wire [31:0] rs1_data, rs2_data;
    wire [31:0] write_back_data;

    register_file u_rf (
        .clk (clock),
        .we  (regwrite),
        .rs1 (rs1_addr),
        .rs2 (rs2_addr),
        .rd  (rd_addr),
        .wd  (write_back_data),
        .rd1 (rs1_data),
        .rd2 (rs2_data)
    );

    
    // Immediate Generator
   
    wire [31:0] imm_ext;

    imm_generator u_immgen (
        .instruction (instruction),
        .imm_ext     (imm_ext)
    );

   
    // ALU operand muxes
    
    wire [31:0] alu_op_a;
    wire [31:0] alu_op_b;

    // alusrca: 00 = rs1, 01 = pc (AUIPC), 10 = 0 (LUI)
    mux3 #(.WIDTH(32)) u_mux_alu_a (
        .in0 (rs1_data),
        .in1 (pc_current),
        .in2 (32'b0),
        .sel (alusrca),
        .out (alu_op_a)
    );

    // alusrcb: 0 = rs2, 1 = immediate
    mux2 #(.width(32)) u_mux_alu_b (
        .in0 (rs2_data),
        .in1 (imm_ext),
        .sel (alusrcb),
        .out (alu_op_b)
    );

    
    // ALU Control + ALU
    
    wire [3:0]  alu_ctrl_sig;
    wire [31:0] alu_result;
    wire        alu_zero;

    alu_ctrl u_aluctrl (
        .alu_op      (aluop),
        .function3   (funct3),
        .function7_5 (funct7_5),
        .opcode      (opcode),
        .alu_control (alu_ctrl_sig)
    );

    alu u_alu (
        .a        (alu_op_a),
        .b        (alu_op_b),
        .alu_ctrl (alu_ctrl_sig),
        .result   (alu_result),
        .zero     (alu_zero)
    );

   
    // Branch comparator
  
    wire branch_taken;

    branch_comp u_bcomp (
        .rs1_val      (rs1_data),
        .rs2_val      (rs2_data),
        .funct3       (funct3),
        .branch_taken (branch_taken)
    );

   
    // Data Memory
    
    wire [31:0] mem_read_data;

    data_memory #(.MEM_WORDS(DMEM_WORDS)) u_dmem (
        .clk        (clock),
        .addr       (alu_result),
        .write_data (rs2_data),
        .MemWrite   (memwrite),
        .MemRead    (memread),
        .read_data  (mem_read_data)
    );

   
    // Write-back mux: 00 = alu_result, 01 = mem_read_data, 10 = pc+4
    
    mux3 #(.WIDTH(32)) u_mux_wb (
        .in0 (alu_result),
        .in1 (mem_read_data),
        .in2 (pc_plus4),
        .sel (memtoreg),
        .out (write_back_data)
    );

    
    // PC source select mux: 00 = pc+4, 01 = branch/jal target, 10 = jalr target
   
    reg [1:0] pcsrc_sel;

    always @(*) begin
        if (jump) begin
            if (is_jalr)
                pcsrc_sel = 2'b10;
            else
                pcsrc_sel = 2'b01;
        end else if (branch && branch_taken) begin
            pcsrc_sel = 2'b01;
        end else begin
            pcsrc_sel = 2'b00;
        end
    end

    mux3 #(.WIDTH(32)) u_mux_pc (
        .in0 (pc_plus4),
        .in1 (pc_branch_target),
        .in2 (pc_jalr_target),
        .sel (pcsrc_sel),
        .out (pc_next)
    );

endmodule