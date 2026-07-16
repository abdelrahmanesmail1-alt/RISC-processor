`timescale 1ns / 1ps

module riscv_top_tb;

    // Inputs
    reg clock;
    reg rst;

    // Instantiate the Unit Under Test (UUT)
    riscv_top uut (
        .clock(clock), 
        .rst(rst)
    );

    // Clock generation
    always #5 clock = ~clock; // 10ns clock period

    initial begin
        // Initialize Inputs
        clock = 0;
        rst = 1;

        // Wait for global reset
        #20;
        rst = 0;
        
        // Let the simulation run for a certain period
        // You can add more simulation logic here if needed
        #200;
        
        // Finish simulation
        $finish;
    end

    // Monitor signals to observe the processor execution
    initial begin
        $monitor("Time=%0t | PC=%h | Instr=%h", $time, uut.pc_current, uut.instruction);
    end

endmodule