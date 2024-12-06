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
    wire note_valid;
    wire [7:0] wav_out;

    // Processor to synth interface signals
    wire [7:0] proc_port_addr;
    wire [7:0] proc_data_out;
    wire [7:0] proc_data_in;
    wire proc_read_e;
    wire proc_write_e;

    // Synth control signals
    wire [1:0] wav_sel;
    wire [2:0] attack_time;
    wire [2:0] decay_time;
    wire [3:0] sustain_level;
    wire [2:0] release_time;

    // Instantiate the Natalius processor
    natalius_processor processor_inst(
        .clk(clk),
        .rst(reset),
        .port_addr(proc_port_addr),
        .read_e(proc_read_e),
        .write_e(proc_write_e),
        .data_in(proc_data_in),
        .data_out(proc_data_out)
    );

    // Instantiate the synthesizer interface
    synth_interface synth_if_inst(
        .clk(clk),
        .reset(reset),
        // Processor side
        .port_addr(proc_port_addr),
        .data_in(proc_data_out),
        .data_out(proc_data_in),
        .write_e(proc_write_e),
        .read_e(proc_read_e),
        // Synthesizer side
        .wav_sel(wav_sel),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time)
    );

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