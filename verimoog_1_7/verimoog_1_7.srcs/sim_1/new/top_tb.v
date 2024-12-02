`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 08:18:41 PM
// Design Name: 
// Module Name: top_tb
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

module top_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [6:0] midi_in;
    reg note_on;
    reg [1:0] wav_sel;
    reg [15:0] attack_time;
    reg [15:0] decay_time;
    reg [7:0] sustain_level;
    reg [15:0] release_time;
    wire pwm_audio_out;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .midi_in(midi_in),
        .note_on(note_on),
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .pwm_audio_out(pwm_audio_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        midi_in = 0;
        note_on = 0;
        wav_sel = 0;
        attack_time = 100;    // 100ms attack
        decay_time = 200;     // 200ms decay
        sustain_level = 128;  // 50% sustain
        release_time = 300;   // 300ms release

        // Wait 100ns and release reset
        #100;
        reset = 0;
        #100;

        // Test 1: Basic note functionality
        $display("Test 1: Testing basic note functionality");
        midi_in = 7'd60;  // Middle C
        #100;
        note_on = 1;
        #1000000;  // Wait 1ms to see the note
        note_on = 0;
        #1000000;  // Wait 1ms to see the release

        // Test 2: Waveform selection
        $display("Test 2: Testing waveform selection");
        // Test each waveform with middle C
        wav_sel = 2'b00;  // Sawtooth
        #100;
        note_on = 1;
        #1000000;
        note_on = 0;
        #1000000;

        wav_sel = 2'b01;  // Square
        #100;
        note_on = 1;
        #1000000;
        note_on = 0;
        #1000000;

        // Test 3: ADSR behavior
        $display("Test 3: Testing ADSR envelope");
        wav_sel = 2'b00;  // Back to sawtooth
        attack_time = 50;     // Fast attack
        decay_time = 100;     // Fast decay
        sustain_level = 192;  // High sustain
        release_time = 150;   // Medium release
        
        note_on = 1;
        #2000000;  // Hold note
        note_on = 0;
        #2000000;  // Release

        $display("Tests complete");
        #100;
        $finish;
    end

    // Monitor PWM output
    initial begin
        $monitor("Time=%0t pwm_out=%b", $time, pwm_audio_out);
    end

    // Create VCD file for waveform viewing
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

endmodule
