`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Elias N. Chokeir
// 
// Create Date: 09/26/2024 04:01:17 PM
// Design Name: Clock Divider
// Module Name: clk_div
// Project Name: Final Project
// Target Devices: Basys 3
// Tool Versions: 2023.10
// Description: Clock divider from 50MHz to 440Hz
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
// Calculations: TOGGLE_COUNT = 50000000 / ( 2 * 440 ) = 56818
//////////////////////////////////////////////////////////////////////////////////


module clk_div(
    input wire clk,
    input wire reset,
    output reg clk_out
    );
    
    //clk freq params
    parameter CLOCK_FREQ = 50000000;                    //input freq 50Mhz
    parameter FREQ = 440;                               //output freq goal 440Hz;
    
    //counter toggle point
    localparam TOGGLE_COUNT = CLOCK_FREQ / (1 * FREQ);  //clks per half period
    
    //counter
    reg [31:0] counter = 0;
    
    //clk div logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin                                //reset
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter >= TOGGLE_COUNT) begin          //if counter over, flip
                clk_out <= ~clk_out;                    //flip clk_out
                counter <= 0;
            end else begin                              //if not
                counter <= counter + 1;                 //counter++
            end
        end
    end
endmodule
