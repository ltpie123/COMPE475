`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: Waveform Selector
// Module Name: wav_selector
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Multiplexer for selecting between different waveform generators.
//    Supports saw, square, triangle, and sine waveforms.
//
// Key Features:
//    - Four waveform types
//    - Glitch-free switching
//    - Voice activity gating
//    - Default to mid-scale when inactive
//
// Signal Information:
//    Inputs:
//        clk           - 100MHz system clock
//        reset         - Active high reset
//        wav_sel[1:0]  - Waveform selection control
//                        00: Sawtooth
//                        01: Square
//                        10: Triangle
//                        11: Sine
//        freq          - 32-bit frequency word
//        voice_active  - Voice gate control
//    Outputs:
//        wav_out       - Selected 8-bit waveform
//
// Implementation Notes:
//    - Combinatorial output selection
//    - Mid-scale (0x80) output when inactive
//    - Instantiates all waveform generators
//    - No output smoothing on switches
//
// Resource Usage:
//    - Four waveform generator instances
//    - Simple multiplexer logic
//    - Shared frequency input
//
// Dependencies:
//    - saw_wav_gen.v
//    - sqr_wav_gen.v
//    - tri_wav_gen.v
//    - sin_wav_gen.v
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could add crossfading between waveforms
//    - Consider adding waveform mixing capability
//////////////////////////////////////////////////////////////////////////////////

module wav_selector(
    input wire clk,
    input wire reset,
    input wire [1:0] wav_sel,
    input wire [31:0] freq,
    input wire voice_active,     
    output reg [7:0] wav_out
);
    // Wave generator outputs
    wire [7:0] sqr_wav_out;
    wire [7:0] sin_wav_out;
    wire [7:0] saw_wav_out;
    wire [7:0] tri_wav_out;

    // Simple wave generators for testing
    sqr_wav_gen sqr_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(sqr_wav_out)
    );

    sin_wav_gen sin_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(sin_wav_out)
    );

    saw_wav_gen saw_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(saw_wav_out)
    );

    tri_wav_gen tri_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(tri_wav_out)
    );

    // Super simple output selection - no intermediate registers
    always @* begin
        if (reset)
            wav_out = 8'h80;
        else if (!voice_active)
            wav_out = 8'h80;
        else case (wav_sel)
            2'b00: wav_out = saw_wav_out;
            2'b01: wav_out = sqr_wav_out;
            2'b10: wav_out = tri_wav_out;
            2'b11: wav_out = sin_wav_out;
            default: wav_out = saw_wav_out;
        endcase
    end

endmodule