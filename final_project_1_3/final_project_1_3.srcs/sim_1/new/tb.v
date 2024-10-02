`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 04:23:16 PM
// Design Name: 
// Module Name: tb
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

module tb;
    
    reg clk;
    reg reset;
    reg [6:0] midi_in;
    reg [1:0] wav_sel;
    wire [7:0] wav_out;
    
    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .midi_in(midi_in),
        .wav_sel(wav_sel),
        .wav_out(wav_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock (10ns period)
    
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        midi_in = 7'd60;  // Middle C (MIDI note for C4)
        wav_sel = 2'b00;  // Square wave
        
        // Apply reset
        #10;
        reset = 0;
        
        // Test each waveform
        #100000;
        $display("Testing square wave");
        wav_sel = 2'b00;   // Select square wave
        #100000;
        
        $display("Testing sine wave");
        wav_sel = 2'b01;   // Select sine wave
        #100000;
        
        $display("Testing sawtooth wave");
        wav_sel = 2'b10;   // Select sawtooth wave
        #100000;
        
        $display("Testing triangle wave");
        wav_sel = 2'b11;   // Select triangle wave
        #100000;
        
        // Test different MIDI input (change frequency)
        $display("Testing different MIDI input for sine wave");
        midi_in = 7'd69;   // A4 (440 Hz)
        wav_sel = 2'b01;   // Select sine wave
        #100000;
        
        // End simulation
        $finish;
    end
    
endmodule

