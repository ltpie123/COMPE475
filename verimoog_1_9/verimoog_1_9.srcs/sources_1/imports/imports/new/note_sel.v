`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/01/2024 09:13:21 PM
// Design Name:
// Module Name: note_sel
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


module note_sel(
    input [6:0] note_in,        // 7-bit note input (e.g., from MIDI or keyboard)
    output reg [31:0] freq   // Corresponding frequency output
);

    always @(*) begin
        case(note_in)
            // First Octave (C4 to B4)
            7'd60: freq = 32'd26163;   // C4 (261.63 Hz)
            7'd61: freq = 32'd27718;   // C#4/Db4 (277.18 Hz)
            7'd62: freq = 32'd29366;   // D4 (293.66 Hz)
            7'd63: freq = 32'd31113;   // D#4/Eb4 (311.13 Hz)
            7'd64: freq = 32'd32963;   // E4 (329.63 Hz)
            7'd65: freq = 32'd34923;   // F4 (349.23 Hz)
            7'd66: freq = 32'd36999;   // F#4/Gb4 (369.99 Hz)
            7'd67: freq = 32'd39200;   // G4 (392.00 Hz)
            7'd68: freq = 32'd41530;   // G#4/Ab4 (415.30 Hz)
            7'd69: freq = 32'd44000;   // A4 (440.00 Hz)
            7'd70: freq = 32'd46616;   // A#4/Bb4 (466.16 Hz)
            7'd71: freq = 32'd49388;   // B4 (493.88 Hz)

            // Second Octave (C5 to B5)
            7'd72: freq = 32'd52325;   // C5 (523.25 Hz)
            7'd73: freq = 32'd55437;   // C#5/Db5 (554.37 Hz)
            7'd74: freq = 32'd58733;   // D5 (587.33 Hz)
            7'd75: freq = 32'd62225;   // D#5/Eb5 (622.25 Hz)
            7'd76: freq = 32'd65925;   // E5 (659.25 Hz)
            7'd77: freq = 32'd69846;   // F5 (698.46 Hz)
            7'd78: freq = 32'd73999;   // F#5/Gb5 (739.99 Hz)
            7'd79: freq = 32'd78399;   // G5 (783.99 Hz)
            7'd80: freq = 32'd83061;   // G#5/Ab5 (830.61 Hz)
            7'd81: freq = 32'd88000;   // A5 (880.00 Hz)
            7'd82: freq = 32'd93233;   // A#5/Bb5 (932.33 Hz)
            7'd83: freq = 32'd98777;   // B5 (987.77 Hz)

            default: freq = 32'd0;     // No frequency for undefined notes
        endcase
    end

endmodule
