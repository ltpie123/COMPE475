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

module instruction_memory(
    input clk,
    input [10:0] address,
    output reg [15:0] instruction
);

    (* RAM_STYLE="BLOCK" *)
    reg [15:0] rom [2047:0];
    integer i;
    
    // Memory initialization and program loading
    initial begin
        // First clear all memory
        for (i = 0; i < 2048; i = i + 1)
            rom[i] = 16'h0000;
        
        // Try to load from file
        $readmemh("instructions.mem", rom);
        
        // Check first few locations and display
        $display("Instruction Memory Contents:");
        for (i = 0; i < 16; i = i + 1)
            $display("Addr %0h: %h", i, rom[i]);
            
        // Initialize instruction output
        instruction = 16'h0000;
    end

    // Synchronous read
    always @(posedge clk) begin
        instruction <= rom[address];
        $display("Reading instruction at addr=%h: %h", address, rom[address]);
    end

endmodule