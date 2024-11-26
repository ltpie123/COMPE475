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


// synth.v
module synth #(
    parameter NUM_VOICES = 8
)(
    input wire clk,
    input wire reset,
    input wire [6:0] midi_note,
    input wire note_on,
    input wire note_valid,
    input wire [1:0] wav_sel,

    // ADSR controls
    input wire [15:0] attack_time,
    input wire [15:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [15:0] release_time,

    output wire [7:0] wav_out
);

    // Voice manager signals
    wire [NUM_VOICES-1:0] voice_active;
    wire [(NUM_VOICES*7)-1:0] voice_notes;
    wire [NUM_VOICES-1:0] voice_trigger;
    wire [3:0] active_voice_count;

    // Per-voice frequency signals
    wire [(NUM_VOICES*32)-1:0] voice_freq;

    // Per-voice wave generator outputs
    wire [(NUM_VOICES*8)-1:0] voice_raw;

    // Per-voice envelope outputs
    wire [(NUM_VOICES*8)-1:0] voice_envelope;

    // Voice manager instance
    voice_manager #(
        .NUM_VOICES(NUM_VOICES)
    ) voice_manager_inst (
        .clk(clk),
        .reset(reset),
        .midi_note(midi_note),
        .note_on(note_on),
        .note_valid(note_valid),
        .voice_active(voice_active),
        .voice_notes(voice_notes),
        .voice_trigger(voice_trigger),
        .active_voice_count(active_voice_count)
    );

    // Generate per-voice frequencies
    genvar v;
    generate
        for (v = 0; v < NUM_VOICES; v = v + 1) begin : voice_freq_gen
            midi_to_freq midi_freq_inst (
                .midi_in(voice_notes[v*7 +: 7]),
                .freq_out(voice_freq[v*32 +: 32])
            );
        end
    endgenerate

    // Generate waveforms for each voice
    generate
        for (v = 0; v < NUM_VOICES; v = v + 1) begin : voice_wav_gen
            wav_selector wav_sel_inst (
                .clk(clk),
                .reset(reset),
                .wav_sel(wav_sel),
                .freq(voice_freq[v*32 +: 32]),
                .voice_active(voice_active[v]),
                .voice_trigger(voice_trigger[v]),
                .wav_out(voice_raw[v*8 +: 8])
            );
        end
    endgenerate

    // ADSR envelope generator
    adsr_envelope #(
        .NUM_VOICES(NUM_VOICES)
    ) adsr_inst (
        .clk(clk),
        .reset(reset),
        .voice_trigger(voice_trigger),
        .voice_active(voice_active),
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .voice_in(voice_raw),
        .voice_out(voice_envelope)
    );

    // Voice mixer
    voice_mixer #(
        .NUM_VOICES(NUM_VOICES)
    ) mixer_inst (
        .clk(clk),
        .reset(reset),
        .voice_in(voice_envelope),
        .voice_active(voice_active),
        .mix_out(wav_out)
    );

endmodule