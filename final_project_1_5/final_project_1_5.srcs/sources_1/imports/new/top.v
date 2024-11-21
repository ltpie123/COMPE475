`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/26/2024 03:59:46 PM
// Design Name:
// Module Name: top
// Project Name:
// Target Devices: Basys 3
// Tool Versions:
// Description:
//    Top level module for synthesizer with PWM audio output
//
// Dependencies:
//    synth.v
//    pwm_audio.v
//
//////////////////////////////////////////////////////////////////////////////////

module top(
    input wire clk,             // 100MHz system clock
    input wire reset,           // Active high reset
    input wire [6:0] midi_in,   // MIDI note input
    input wire [1:0] wav_sel,   // Waveform selector
    output wire pwm_audio_out   // PWM audio output pin
);

    // Internal signals
    wire [7:0] wav_out;

    // Instantiate synthesizer
    synth synth_inst(
        .clk(clk),
        .reset(reset),
        .midi_in(midi_in),
        .wav_sel(wav_sel),
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
