`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: Synthesizer Core
// Module Name: synth
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Core synthesizer module combining MIDI processing, waveform generation,
//    and envelope control for a single voice synthesizer.
//
// Key Features:
//    - MIDI note to frequency conversion
//    - Multiple waveform options
//    - ADSR envelope modulation
//    - Single voice polyphony
//
// Signal Information:
//    Inputs:
//        clk             - 100MHz system clock
//        reset           - Active high reset
//        midi_note[6:0]  - MIDI note number
//        note_on         - Note trigger control
//        wav_sel[1:0]    - Waveform selection
//        attack_time     - Attack phase duration
//        decay_time      - Decay phase duration
//        sustain_level   - Sustain amplitude
//        release_time    - Release phase duration
//    Outputs:
//        wav_out[7:0]    - Final audio output
//
// Signal Chain:
//    MIDI Note -> Frequency -> Waveform -> ADSR -> Output
//
// Implementation Notes:
//    - Synchronous design throughout
//    - Instantiates key processing blocks
//    - Single sample processing path
//    - No internal buffering
//
// Dependencies:
//    - midi_to_freq.v
//    - wav_selector.v
//    - adsr_envelope.v
//
// Performance:
//    - Single cycle latency per block
//    - Full MIDI note range support
//    - 8-bit audio resolution
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Consider adding velocity sensitivity
//    - Could implement polyphony
//    - Possible effects processing stage
//////////////////////////////////////////////////////////////////////////////////

module synth(
    input wire clk,
    input wire reset,
    input wire [6:0] midi_note,
    input wire note_on,
    input wire note_valid,
    input wire [1:0] wav_sel,
    input wire [15:0] attack_time,
    input wire [15:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [15:0] release_time,
    output wire [7:0] wav_out
);
    // Pipeline registers for control signals
    reg [6:0] midi_note_reg1, midi_note_reg2;
    reg note_on_reg1, note_on_reg2;
    reg note_valid_reg1, note_valid_reg2;
    reg [1:0] wav_sel_reg1, wav_sel_reg2;
    
    // ADSR pipeline registers
    reg [15:0] attack_reg1, attack_reg2;
    reg [15:0] decay_reg1, decay_reg2;
    reg [7:0] sustain_reg1, sustain_reg2;
    reg [15:0] release_reg1, release_reg2;

    // Internal signals
    wire [31:0] voice_freq;
    wire [7:0] voice_raw;

    // First stage - register all inputs
    always @(posedge clk) begin
        if (reset) begin
            midi_note_reg1 <= 7'd0;
            midi_note_reg2 <= 7'd0;
            note_on_reg1 <= 1'b0;
            note_on_reg2 <= 1'b0;
            note_valid_reg1 <= 1'b0;
            note_valid_reg2 <= 1'b0;
            wav_sel_reg1 <= 2'b00;
            wav_sel_reg2 <= 2'b00;
            
            attack_reg1 <= 16'd0;
            attack_reg2 <= 16'd0;
            decay_reg1 <= 16'd0;
            decay_reg2 <= 16'd0;
            sustain_reg1 <= 8'd0;
            sustain_reg2 <= 8'd0;
            release_reg1 <= 16'd0;
            release_reg2 <= 16'd0;
        end else begin
            midi_note_reg1 <= midi_note;
            midi_note_reg2 <= midi_note_reg1;
            note_on_reg1 <= note_on;
            note_on_reg2 <= note_on_reg1;
            note_valid_reg1 <= note_valid;
            note_valid_reg2 <= note_valid_reg1;
            wav_sel_reg1 <= wav_sel;
            wav_sel_reg2 <= wav_sel_reg1;
            
            attack_reg1 <= attack_time;
            attack_reg2 <= attack_reg1;
            decay_reg1 <= decay_time;
            decay_reg2 <= decay_reg1;
            sustain_reg1 <= sustain_level;
            sustain_reg2 <= sustain_reg1;
            release_reg1 <= release_time;
            release_reg2 <= release_reg1;
        end
    end

    // Frequency calculation with registered output
    midi_to_freq midi_freq_inst (
        .clk(clk),
        .reset(reset),
        .midi_in(midi_note_reg2),
        .freq_out(voice_freq)
    );

    // Wave generation with registered inputs/outputs
    wav_selector wav_sel_inst (
        .clk(clk),
        .reset(reset),
        .wav_sel(wav_sel_reg2),
        .freq(voice_freq),
        .voice_active(note_on_reg2),
        .wav_out(voice_raw)
    );

    // ADSR envelope with registered inputs/outputs
    adsr_envelope adsr_inst (
        .clk(clk),
        .reset(reset),
        .voice_trigger(note_on_reg2 && note_valid_reg2),
        .voice_active(note_on_reg2),
        .attack_time(attack_reg2),
        .decay_time(decay_reg2),
        .sustain_level(sustain_reg2),
        .release_time(release_reg2),
        .voice_in(voice_raw),
        .voice_out(wav_out)
    );

endmodule
