`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:08:17 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div (
    input wire clk_in,       // Input clock signal
    input wire rst_n,        // Active low reset signal
    output reg clk_out       // Output clock signal
);
    parameter DIVISOR = 4;   // Division factor
    reg [31:0] counter;       // Counter to track clock cycles

    // Always block triggered by the rising edge of clk_in or falling edge of rst_n
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;     // Reset the counter
            clk_out <= 0;     // Reset the output clock
        end else begin
            if (counter < (DIVISOR - 1)) begin
                counter <= counter + 1; // Increment the counter
            end else begin
                counter <= 0;           // Reset the counter
                clk_out <= ~clk_out;    // Toggle the output clock
            end
        end
    end
endmodule
