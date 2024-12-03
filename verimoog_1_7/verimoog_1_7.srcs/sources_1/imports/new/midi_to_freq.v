`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: MIDI Note to Frequency Converter
// Module Name: midi_to_freq
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Converts MIDI note numbers to corresponding frequencies in Hz.
//    Implements lookup table for standard 12-tone equal temperament.
//
// Key Features:
//    - Direct MIDI note to frequency conversion
//    - 3-octave range (C3 to C6)
//    - Standard A4=440Hz tuning
//    - Zero-latency lookup
//
// Signal Information:
//    Inputs:
//        midi_in[6:0]  - MIDI note number (48-84 valid)
//    Outputs:
//        freq_out[31:0] - Frequency in Hz
//
// Implementation Notes:
//    - Case statement-based lookup table
//    - Returns 0 Hz for invalid notes
//    - Fixed-point integer frequencies
//    - No interpolation between notes
//
// Musical Notes:
//    - A4 (MIDI 69) = 440 Hz
//    - Middle C (MIDI 60) = 262 Hz
//    - Covers C3 (MIDI 48) to C6 (MIDI 84)
//
// Frequency Table Generation:
//    fn = 440 * 2^((n-69)/12) where n is MIDI note number
//    All frequencies rounded to nearest integer
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could extend range of supported notes
//    - Consider adding cents/fine tuning
//    - Possible support for alternate tunings
//////////////////////////////////////////////////////////////////////////////////


module midi_to_freq(
    input wire [6:0] midi_in,
    output reg [31:0] freq_out
    );

    initial begin
        freq_out = 32'd0;
    end

    always@(midi_in) begin
        case(midi_in)
            7'd48: freq_out = 32'd131;      // C3
            7'd49: freq_out = 32'd139;      // C#3 / Db3
            7'd50: freq_out = 32'd147;      // D3
            7'd51: freq_out = 32'd156;      // D#3 / Eb3
            7'd52: freq_out = 32'd165;      // E3
            7'd53: freq_out = 32'd175;      // F3
            7'd54: freq_out = 32'd185;      // F#3 / Gb3
            7'd55: freq_out = 32'd196;      // G3
            7'd56: freq_out = 32'd208;      // G#3 / Ab3
            7'd57: freq_out = 32'd220;      // A3
            7'd58: freq_out = 32'd233;      // A#3 / Bb3
            7'd59: freq_out = 32'd247;      // B3
            7'd60: freq_out = 32'd262;      // C4 (Middle C)
            7'd61: freq_out = 32'd277;      // C#4 / Db4
            7'd62: freq_out = 32'd294;      // D4
            7'd63: freq_out = 32'd311;      // D#4 / Eb4
            7'd64: freq_out = 32'd330;      // E4
            7'd65: freq_out = 32'd349;      // F4
            7'd66: freq_out = 32'd370;      // F#4 / Gb4
            7'd67: freq_out = 32'd392;      // G4
            7'd68: freq_out = 32'd415;      // G#4 / Ab4
            7'd69: freq_out = 32'd440;      // A4 (Concert A)
            7'd70: freq_out = 32'd466;      // A#4 / Bb4
            7'd71: freq_out = 32'd494;      // B4
            7'd72: freq_out = 32'd523;      // C5
            7'd73: freq_out = 32'd554;      // C#5 / Db5
            7'd74: freq_out = 32'd587;      // D5
            7'd75: freq_out = 32'd622;      // D#5 / Eb5
            7'd76: freq_out = 32'd659;      // E5
            7'd77: freq_out = 32'd698;      // F5
            7'd78: freq_out = 32'd740;      // F#5 / Gb5
            7'd79: freq_out = 32'd784;      // G5
            7'd80: freq_out = 32'd831;      // G#5 / Ab5
            7'd81: freq_out = 32'd880;      // A5
            7'd82: freq_out = 32'd932;      // A#5 / Bb5
            7'd83: freq_out = 32'd988;      // B5
            7'd84: freq_out = 32'd1047;     // C6
            default: freq_out = 32'd0;
        endcase
    end

endmodule
