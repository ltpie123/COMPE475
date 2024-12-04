`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Elias Chokeir
//
// Create Date: 09/26/2024 03:59:46 PM
// Design Name:
// Module Name: top
// Project Name:
// Target Devices: Basys 3
// Tool Versions:
// Description:
//    Top level module for synthesizer with PWM audio output and MIDI input
//
// Dependencies:
//    synth.v
//    pwm_audio.v
//    midi_input.v
//
//////////////////////////////////////////////////////////////////////////////////

module top(
    input wire clk,             // 100MHz system clock
    input wire reset,           // Active high reset
    input wire midi_rx,         // MIDI serial input
    input wire [1:0] wav_sel,   // Waveform selector
    // ADSR controls with reduced bit widths
    input wire [2:0] attack_time,    // Reduced from [15:0]
    input wire [2:0] decay_time,     // Reduced from [15:0]
    input wire [3:0] sustain_level,  // Reduced from [7:0]
    input wire [2:0] release_time,   // Reduced from [15:0]
    output wire pwm_audio_out        // PWM audio output pin
);

    // Internal signals from MIDI input module
    wire [6:0] midi_note;
    wire note_on;
    wire note_valid;
    wire [7:0] wav_out;

    // Internal extended ADSR signals
    wire [15:0] attack_time_ext = {5'b0, attack_time, 8'b0};  // Scale to proper range
    wire [15:0] decay_time_ext = {5'b0, decay_time, 8'b0};    // Scale to proper range
    wire [7:0] sustain_level_ext = {sustain_level, 4'b0};     // Scale to 8 bits
    wire [15:0] release_time_ext = {5'b0, release_time, 8'b0}; // Scale to proper range

    // Instantiate MIDI input module
    midi_input midi_input_inst(
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid)
    );

    // Instantiate synthesizer
    synth synth_inst(
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid),
        .wav_sel(wav_sel),
        .attack_time(attack_time_ext),
        .decay_time(decay_time_ext),
        .sustain_level(sustain_level_ext),
        .release_time(release_time_ext),
        .wav_out(wav_out)
    );

    // Instantiate PWM audio output
    pwm_audio pwm_audio_inst(
        .clk(clk),
        .reset(reset),
        .audio_in(wav_out),
        .pwm_out(pwm_audio_out)
    );

endmodule