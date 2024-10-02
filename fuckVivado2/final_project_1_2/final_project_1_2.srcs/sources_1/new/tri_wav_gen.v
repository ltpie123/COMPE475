`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 07:55:33 PM
// Design Name: 
// Module Name: tri_wav_gen
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


module tri_wav_gen(
    input wire clk,
    input wire [31:0] freq,
    output reg [7:0] wav_out
    );
    
    reg [31:0] counter;
    reg [31:0] max;
    reg direction;
    
    always @(posedge clk) begin
        max <= 50000000 / freq;                     //asdf
        
        if (counter < max - 1) begin                //counter
            counter <= counter + 1;                 //counter++
        end else begin
            counter <= 0;                           //counter reset
            
            if (direction) begin                    
                if (wav_out < 255) begin            //ramp up
                    wav_out <= wav_out + 1;
                end else begin
                    direction <= 0;                 //change direction
                end
            end else begin
                if (wav_out > 0) begin
                    wav_out <= wav_out - 1;         //ramp down
                end else begin
                    direction <= 1;                 //change direction
                end
            end
        end
    end
    
    initial begin
        direction = 1;                              //starts ramp up
        wav_out = 0;                                //init wav_out
    end
endmodule
