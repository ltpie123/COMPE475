`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/26/2024 07:26:44 PM
// Design Name:
// Module Name: synth
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

`timescale 1ns / 1ps
module synth(
    input wire clk,
    input wire reset,
    input wire [6:0] midi_note,
    input wire note_on,
    input wire [1:0] wav_sel,
    // ADSR controls
    input wire [15:0] attack_time,
    input wire [15:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [15:0] release_time,
    output wire [7:0] wav_out
);
    // Single voice frequency signal
    wire [31:0] voice_freq;
    // Single voice wave output
    wire [7:0] voice_raw;
    // Single voice envelope output
    wire [7:0] voice_envelope;

    // Frequency calculation
    midi_to_freq midi_freq_inst (
        .midi_in(midi_note),
        .freq_out(voice_freq)
    );

    // Wave generation
    wav_selector wav_sel_inst (
        .clk(clk),
        .reset(reset),
        .wav_sel(wav_sel),
        .freq(voice_freq),
        .voice_active(note_on),    // Keep this connection
        .wav_out(voice_raw)        // This should now work properly
    );

    // ADSR envelope generator
    adsr_envelope adsr_inst (
        .clk(clk),
        .reset(reset),
        .voice_trigger(note_on),
        .voice_active(note_on),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .voice_in(voice_raw),
        .voice_out(wav_out)
    );

endmodule