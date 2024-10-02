`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 07:51:24 PM
// Design Name: 
// Module Name: saw_wav_gen
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


module saw_wav_gen(
    input wire clk,
    input wire [31:0] freq,
    output reg [7:0] wav_out
    );
    
    reg [31:0] counter;
    reg [31:0] max;
    
    always @(posedge clk) begin
        max <= 50000000 / freq;                             //adjusts max based on freq
        if (counter < max - 1)begin
            counter <= counter + 1;                         //counter++ 
        end else begin
            counter <= 0;                                   //reset counter
            wav_out <= (wav_out == 255) ? 0 : wav_out + 1;  //wraps after max
        end
    end
endmodule
