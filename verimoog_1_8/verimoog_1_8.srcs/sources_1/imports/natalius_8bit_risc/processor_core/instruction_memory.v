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

    // Initialize with default values
    initial begin
        instruction <= 16'h0000;
        for (integer i = 0; i < 2048; i = i + 1)
            rom[i] = 16'h0000;
        $readmemh("instructions.mem", rom);
    end


    always @(posedge clk)
        instruction <= rom[address];

endmodule