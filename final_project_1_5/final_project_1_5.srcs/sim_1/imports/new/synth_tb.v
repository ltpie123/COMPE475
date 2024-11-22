`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 09:30:52 PM
// Design Name: 
// Module Name: synth_tb
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


module synth_tb;

    reg clk;
    reg reset;
    reg [6:0] midi_in;
    reg [1:0] wav_sel;
    wire [7:0] wav_out;
    
    synth uut (
        .clk(clk),
        .reset(reset),
        .midi_in(midi_in),
        .wav_sel(wav_sel),
        .wav_out(wav_out)
    );
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        reset = 1;
        
        #20
        
        reset = 0;
        
        wav_sel = 2'b00;
        midi_in = 7'd60;
        #1000;
        
        midi_in = 7'd72;
        #1000;
        
        midi_in = 7'd48;
        #1000;
        
        wav_sel = 2'b01;
        midi_in = 7'd60;
        #1000;
        
        midi_in = 7'd72;
        #1000;
        
        midi_in = 7'd48;
        #1000;
        
        wav_sel = 2'b10;
        midi_in = 7'd60;
        #1000;
        
        midi_in = 7'd72;
        #1000;
        
        midi_in = 7'd48;
        #1000;
        
        wav_sel = 2'b11;
        midi_in = 7'd60;
        #1000;
        
        midi_in = 7'd72;
        #1000;
        
        midi_in = 7'd48;
        #1000;
        
        reset = 1;
        
        $finish;
    end 
endmodule
