`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:13:01 PM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_divider (
    input wire clk,
    input wire rst_n,
    output reg clk_out,
    output reg clk_enable
);
    parameter BAUD_RATE_DIV = 10417; // Adjusted for 9600 baud rate with 100 MHz clk
    reg [13:0] count; // Adjusted to accommodate larger count

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            clk_out <= 0;
            clk_enable <= 0;
        end else begin
            if (count < BAUD_RATE_DIV - 1) begin
                count <= count + 1;
                clk_enable <= 0;
            end else begin
                count <= 0;
                clk_out <= ~clk_out; // Toggle clock output
                clk_enable <= 1;      // Enable clock for transmission
            end
        end
    end
endmodule
