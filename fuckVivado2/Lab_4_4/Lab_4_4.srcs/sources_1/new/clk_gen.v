`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:05:35 PM
// Design Name: 
// Module Name: clk_gen
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


module clk_gen (
    input wire clk,     // Input clock signal
    input wire rst_n,      // Active low reset
    output reg clk_out     // Output clock signal
);
    parameter DIVISOR = 4; // Set the clock division factor
    reg [31:0] counter;     // Counter to track clock cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter < (DIVISOR - 1)) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle output clock
            end
        end
    end
endmodule
