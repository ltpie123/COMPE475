`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:24 05/02/2012 
// Design Name: 
// Module Name:    regfile 
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

module regfile(
    input [7:0] datain,
    input clk, we,
    input [2:0] wa,
    input [2:0] raa,
    input [2:0] rab,
    output [7:0] porta,
    output [7:0] portb
);

    reg [7:0] mem [7:0];

    // Reset logic and write enable
    always @(posedge clk) begin
        if (wa == 0) begin
            mem[0] <= 8'h00;  // R0 is always zero
        end else if (we) begin
            mem[wa] <= datain;
        end
    end

    // Read ports
    assign porta = mem[raa];
    assign portb = mem[rab];

endmodule

