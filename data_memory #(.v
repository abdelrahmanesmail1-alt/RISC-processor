module data_memory #(
    parameter MEM_WORDS = 256
) (
    input  wire        clk,
    input  wire [31:0] addr,        
    input  wire [31:0] write_data,
    input  wire        MemWrite,
    input  wire        MemRead,
    output wire [31:0] read_data
);
 
    reg [31:0] mem [0:MEM_WORDS-1];
    integer i;
 
    initial begin
        for (i = 0; i < MEM_WORDS; i = i + 1)
            mem[i] = 32'b0;
    end
 
    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[31:2]] <= write_data;
    end
 
    assign read_data = MemRead ? mem[addr[31:2]] : 32'b0;
 
endmodule