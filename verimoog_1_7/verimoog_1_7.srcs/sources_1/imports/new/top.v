`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Elias Chokeir
// 
// Create Date: 09/26/2024 03:59:46 PM
// Module Name: top
// Project Name: VeriMoog Synthesizer
// Description:
//    This is the top-level synthesizer module that combines:
//    1. MIDI input processing
//    2. Waveform synthesis
//    3. Envelope control
//    4. PWM audio output
//    
//    The module accepts MIDI input and produces a PWM audio signal with
//    configurable waveform selection and ADSR envelope parameters.
//
// Interface:
//    Clock/Reset:
//        clk             - 100MHz system clock input
//        reset          - Active-high system reset
//    
//    MIDI Interface:
//        midi_rx        - Serial MIDI input (31.25 kbaud)
//    
//    Synthesis Controls:
//        wav_sel[1:0]   - Waveform selection:
//                         00: Sawtooth
//                         01: Square
//                         10: Triangle
//                         11: Sine
//    
//    Envelope Controls:
//        attack_time    - Attack phase duration (0-65535ms)
//        decay_time     - Decay phase duration (0-65535ms)
//        sustain_level  - Sustain amplitude level (0-255)
//        release_time   - Release phase duration (0-65535ms)
//    
//    Audio Output:
//        pwm_audio_out  - PWM modulated audio signal
//
// Operation:
//    1. MIDI messages are received and decoded to note/control information
//    2. Notes are converted to the appropriate frequencies
//    3. Selected waveform is generated at the required frequency
//    4. ADSR envelope is applied to shape the sound
//    5. Final audio is converted to PWM for output
//
// External Requirements:
//    - 100MHz input clock
//    - MIDI input meeting 31.25 kbaud specification
//    - RC low-pass filter on PWM output:
//      * Recommended: R = 1k?, C = 10nF
//      * Cutoff frequency ? 16kHz
//
// Submodules Used:
//    - midi_input:    MIDI protocol decoder
//    - synth:         Core synthesis engine
//    - pwm_audio:     Audio PWM generator
//
//////////////////////////////////////////////////////////////////////////////////

module top(
    input wire clk,             // 100MHz system clock
    input wire reset,           // Active high reset
    input wire midi_rx,         // MIDI serial input
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
    wire [6:0] midi_note;
    wire note_on;
    wire note_valid;

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