`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 11:46:18 AM
// Design Name: 
// Module Name: sin_wav_gen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Testbench for sine wave generator.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sin_wav_gen_tb;

    // Testbench signals
    reg clk;                             // Clock signal
    reg reset;                           // Reset signal
    reg [31:0] freq;                    // Input frequency
    wire [7:0] wav_out;                 // Output waveform

    // Instantiate the sin_wav_gen module
    sin_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;           // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;                      // Assert reset
        freq = 32'h0;                   // Initial frequency set to 0

        // Wait for some time
        #10;
        reset = 0;                      // Release reset
        #10;

        // Test various frequencies
        // MIDI Note 60 (Middle C) - ~261.63 Hz
        freq = 32'd192576;              // Frequency value corresponding to 261.63 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 261.63 Hz (MIDI 60): wav_out = %h", wav_out);

        // MIDI Note 64 (E4) - ~329.63 Hz
        freq = 32'd151685;              // Frequency value corresponding to 329.63 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 329.63 Hz (MIDI 64): wav_out = %h", wav_out);

        // MIDI Note 67 (G4) - ~392.00 Hz
        freq = 32'd127882;              // Frequency value corresponding to 392.00 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 392.00 Hz (MIDI 67): wav_out = %h", wav_out);

        // MIDI Note 72 (C5) - ~523.25 Hz
        freq = 32'd95655;               // Frequency value corresponding to 523.25 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 523.25 Hz (MIDI 72): wav_out = %h", wav_out);

        // MIDI Note 76 (E5) - ~659.25 Hz
        freq = 32'd75853;               // Frequency value corresponding to 659.25 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 659.25 Hz (MIDI 76): wav_out = %h", wav_out);

        // MIDI Note 79 (G5) - ~783.99 Hz
        freq = 32'd63969;               // Frequency value corresponding to 783.99 Hz
        #50000;                        // Wait enough time to observe output
        $display("Testing freq = 783.99 Hz (MIDI 79): wav_out = %h", wav_out);

        // Finish the simulation
        $finish;
    end

endmodule
