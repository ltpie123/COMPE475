
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
    output wire pwm_audio_out   // PWM audio output pin
);

    // Internal signals from MIDI input module
    wire [6:0] midi_note;
    wire note_on;
    wire [7:0] wav_out;

    // Processor interface signals
    wire [7:0] proc_addr;
    wire proc_write;
    wire [7:0] proc_data_in;
    wire [7:0] proc_data_out;

    // Synth control signals
    wire [1:0] wav_sel;
    wire [7:0] attack_time;
    wire [7:0] decay_time;
    wire [7:0] sustain_level;
    wire [7:0] release_time;

    // Synchronized MIDI signals
    wire [6:0] midi_note_sync;
    wire note_on_sync;

    // MIDI input module
    midi_input midi_input_inst(
        .clk(clk),
        .reset(reset),
        .midi_rx(midi_rx),
        .midi_note(midi_note),
        .note_on(note_on)
    );

    // Processor instance
    natalius_processor processor_inst(
        .clk(clk),
        .rst(reset),
        .port_addr(proc_addr),
        .write_e(proc_write),
        .data_in(proc_data_in),
        .data_out(proc_data_out)
    );

    // Processor-Synthesizer interface
    processor_synth_interface interface_inst(
        .clk(clk),
        .rst(reset),
        // Processor side
        .proc_addr(proc_addr),
        .proc_write(proc_write),
        .proc_data_out(proc_data_out),
        .proc_data_in(proc_data_in),
        // MIDI input side
        .midi_note(midi_note),
        .note_on(note_on),
        // Synth control side
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        // Synchronized outputs
        .midi_note_sync(midi_note_sync),
        .note_on_sync(note_on_sync)
    );

    // Synthesizer core
    synth synth_inst(
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note_sync),
        .note_on(note_on_sync),
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .wav_out(wav_out)
    );

    // PWM audio output
    pwm_audio pwm_audio_inst(
        .clk(clk),
        .reset(reset),
        .audio_in(wav_out),
        .pwm_out(pwm_audio_out)
    );

endmodule