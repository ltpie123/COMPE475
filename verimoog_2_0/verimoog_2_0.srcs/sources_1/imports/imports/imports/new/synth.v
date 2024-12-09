
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
    input wire [1:0] wav_sel,
    input wire [7:0] attack_time,
    input wire [7:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [7:0] release_time,
    output wire [7:0] wav_out
);
    // Frequency signal
    wire [31:0] voice_freq;

    // MIDI to frequency conversion
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
        .voice_active(note_on),
        .wav_out(wav_sel_wav_out)
    );

    // ADSR envelope generator
    adsr_envelope adsr_inst (
        .clk(clk),
        .reset(reset),
        .voice_trigger(note_on),
        .voice_active(note_on),
        .attack_time({8'h00, attack_time}),    // Extended to 16 bits
        .decay_time({8'h00, decay_time}),      // Extended to 16 bits
        .sustain_level(sustain_level),
        .release_time({8'h00, release_time}),  // Extended to 16 bits
        .voice_in(wav_sel_wav_out),
        .voice_out(wav_out)
    );

endmodule
