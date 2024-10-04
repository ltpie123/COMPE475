`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024
// Design Name: 
// Module Name: tri_wav_gen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Testbench for the triangle wave generator that plays C3, C4, C5, C6, and A4.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tri_wav_gen_tb;

    reg clk;
    reg reset;
    reg [31:0] freq;
    wire [7:0] wav_out;

    // Instantiate the triangle waveform generator
    tri_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation: 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        freq = 0;

        // Reset the wave generator
        #100;
        reset = 0;
        #100;
        
        // Test: Monitor the phase and wav_out
        $monitor("Time: %0d, Phase: %h, Waveform Output: %h", $time, uut.phase, wav_out);
        
        // Play C3 (frequency = 131 Hz)
        freq = 32'd131;
        #4000;  // Run for some time to play the note

        // Play C4 (frequency = 262 Hz)
        freq = 32'd262;
        #4000;

        // Play C5 (frequency = 523 Hz)
        freq = 32'd523;
        #4000;

        // Play C6 (frequency = 1047 Hz)
        freq = 32'd1047;
        #4000;

        // Play A4 (frequency = 440 Hz)
        freq = 32'd440;
        #4000;

        // Finish simulation
        $finish;
    end

endmodule
