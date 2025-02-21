`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 11:46:18 AM
// Design Name: 
// Module Name: sqr_wav_gen_tb
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

module sqr_wav_gen_tb;

    // Testbench Signals
    reg clk;
    reg reset;
    reg [31:0] freq;   // Input frequency
    wire [7:0] wav_out; // Output waveform

    // Instantiate the sqr_wav_gen module
    sqr_wav_gen uut (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(wav_out)
    );

    // Clock generation: 50 MHz clock (period = 20ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10ns -> 50 MHz
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;         // Assert reset
        freq = 32'h0;      // Initial frequency set to 0
        
        // Wait for some time to ensure reset takes effect
        #100;
        reset = 0;         // De-assert reset

        // Apply different frequencies and observe waveform output
        // Test with various frequencies based on MIDI notes (same as before)
        
        // MIDI Note 60 (Middle C) - ~261.63 Hz
        freq = 32'd192576; // 50M / 261.63 -> 192576
        #50000;            // Wait to observe the output for some time
        
        // MIDI Note 64 (E4) - ~329.63 Hz
        freq = 32'd151685; // 50M / 329.63 -> 151685
        #50000;            // Wait to observe the output

        // MIDI Note 67 (G4) - ~392.00 Hz
        freq = 32'd127882; // 50M / 392.00 -> 127882
        #50000;            // Wait to observe the output
        
        // MIDI Note 72 (C5) - ~523.25 Hz
        freq = 32'd95655;  // 50M / 523.25 -> 95655
        #50000;            // Wait to observe the output
        
        // MIDI Note 76 (E5) - ~659.25 Hz
        freq = 32'd75853;  // 50M / 659.25 -> 75853
        #50000;            // Wait to observe the output

        // MIDI Note 79 (G5) - ~783.99 Hz
        freq = 32'd63969;  // 50M / 783.99 -> 63969
        #50000;            // Wait to observe the output

        // Finish the simulation
        $finish;
    end

endmodule

