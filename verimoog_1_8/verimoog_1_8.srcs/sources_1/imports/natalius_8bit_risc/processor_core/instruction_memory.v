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
    wire we;

    initial begin
        $display("Loading instruction memory...");
        $readmemh("C:/Users/ltpie/Documents/GitHub/COMPE475/verimoog_1_8/verimoog_1_8.srcs/sources_1/new/instructions.mem", rom, 0, 2047);
        // Debug prints
        $display("First instructions loaded:");
        $display("rom[0] = %h", rom[0]);
        $display("rom[1] = %h", rom[1]);
        $display("rom[2] = %h", rom[2]);
    end
		
    assign we = 0;

    always @(posedge clk)
        if(we)
            rom[address] <= 0;
        else
            instruction <= rom[address];

endmodule