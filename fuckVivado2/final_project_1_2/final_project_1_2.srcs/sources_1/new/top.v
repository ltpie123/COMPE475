`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 03:59:46 PM
// Design Name: 
// Module Name: top
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


module top(
    input wire clk,
    input wire reset,
    input wire [6:0] midi_in,
    input wire [1:0] wav_sel,
    output wire [7:0] wav_out
    );
    
    synth synth_inst(
        .clk(clk),
        .reset(reset),
        .midi_in(midi_in),
        .wav_sel(wav_sel),
        .wav_out(wav_out)
    );
    
    
    
endmodule
