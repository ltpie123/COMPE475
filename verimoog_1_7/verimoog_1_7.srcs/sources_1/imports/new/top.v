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
    input wire [6:0] midi_note,  // MIDI note input
    input wire note_on,         // Note on/off control
    input wire note_valid,      // Note valid signal
    input wire [1:0] wav_sel,   // Waveform selector
    // ADSR controls
    input wire [15:0] attack_time,
    input wire [15:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [15:0] release_time,
    output wire pwm_audio_out   // PWM audio output pin
);

    // Internal signals
    wire [7:0] wav_out;

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
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
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