`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024
// Design Name: 
// Module Name: clk_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   This module generates a clock signal with a specified frequency based on an 
//   input clock. It divides the input clock by a specified factor to produce a 
//   lower-frequency output clock.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_gen(
    input wire clk_in,          // Input clock (e.g., 100 MHz)
    input wire reset,           // Reset signal
    output reg clk_out          // Output clock
);
    parameter DIV_FACTOR = 5;   // Clock division factor (change as needed)

    reg [31:0] counter;          // Counter for clock division

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;       // Reset output clock
        end else begin
            if (counter < DIV_FACTOR - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;     // Reset counter
                clk_out <= ~clk_out; // Toggle output clock
            end
        end
    end
endmodule
