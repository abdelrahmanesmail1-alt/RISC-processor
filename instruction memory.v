module instruction_memory  #
    (parameter MEM_WORDS =256 )(
input wire  [31:0] addr,
output wire [31:0] instruction
);
    reg[31:0] mem [0:MEM_WORDS-1];
    assign instruction = mem[addr[31:2]];
    initial begin
        $readmemh("D:/NTI/FPGA/risc v processor/program.txt",mem);
    end
endmodule