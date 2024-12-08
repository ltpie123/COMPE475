`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       Universidad Pontificia Bolivariana
// Engineer:      Fabio Andres Guzman Figueroa
// 
// Create Date:    21:03:05 05/14/2012 
// Design Name: 
// Module Name:    instruction_memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module instruction_memory(
    input clk,
    input [10:0] address,
    output reg [15:0] instruction
);

    (* RAM_STYLE="BLOCK" *)
    reg [15:0] rom [2047:0];
    reg [10:0] last_addr;
    reg init_done;
    integer i;
    integer file_handle;

    // Enhanced initialization with verification
    initial begin
        init_done = 0;
        instruction = 16'h0000;
        
        // Clear memory first
        for (i = 0; i < 2048; i = i + 1)
            rom[i] = 16'h0000;
            
        // Load program with absolute path
        file_handle = $fopen("C:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_9/verimoog_1_9.srcs/sources_1/imports/new/instructions.mem", "r");
        if (file_handle == 0) begin
            $display("Error: Could not open instructions.mem file");
            $finish;
        end
        $fclose(file_handle);
        
        $readmemh("C:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_9/verimoog_1_9.srcs/sources_1/imports/new/instructions.mem", rom);
        
        // Verify critical instructions
        $display("Instruction Memory Verification:");
        $display("0x000: %h (Expected: 0201)", rom[0]);
        $display("0x001: %h (Expected: 4000)", rom[1]);
        $display("0x00A: %h (Expected: 3006)", rom[10]);
        
        // Dump first 16 instructions for debugging
        $display("First 16 instructions in memory:");
        for (i = 0; i < 16; i = i + 1) begin
            $display("Addr %0h: %h", i, rom[i]);
        end
        
        init_done = 1;
    end

    // Address change monitoring
    always @(address) begin
        if (init_done && (address != last_addr)) begin
            $display("Time=%0t Fetching instruction at addr=%h: %h", 
                     $time, address, rom[address]);
            last_addr = address;
        end
    end

    // Synchronous read with debug
    always @(posedge clk) begin
        instruction <= rom[address];
        $display("Time=%0t Reading instruction at addr=%h: %h", 
                 $time, address, rom[address]);
    end

endmodule