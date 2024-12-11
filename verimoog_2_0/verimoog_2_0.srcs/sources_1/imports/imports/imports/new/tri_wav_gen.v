`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: Triangle Wave Generator
// Module Name: tri_wav_gen
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Phase accumulator-based triangle wave generator.
//    Produces symmetrical triangle waves with linear slopes.
//
// Key Features:
//    - Linear rise and fall slopes
//    - Phase-accurate frequency control
//    - 8-bit amplitude resolution
//    - Symmetrical waveform generation
//
// Signal Information:
//    Inputs:
//        clk       - 100MHz system clock
//        reset     - Active high reset
//        freq      - 32-bit frequency control word (Hz)
//    Outputs:
//        wav_out   - 8-bit triangle wave output
//
// Implementation Notes:
//    - Uses phase accumulator for timing
//    - MSB controls slope direction
//    - Linear amplitude mapping
//    - Glitch-free operation
//
// Mathematical Basis:
//    - Phase Increment = (freq * 2^32) / clock_freq
//    - Rising Edge: Direct mapping of phase bits
//    - Falling Edge: Inverted mapping of phase bits
//
// Performance:
//    - Frequency Range: 0-20kHz practical
//    - Phase Resolution: 32 bits
//    - Amplitude Resolution: 8 bits
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Consider adding bandwidth limiting
//    - Could implement variable slope rates
//////////////////////////////////////////////////////////////////////////////////

module tri_wav_gen(
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] freq_reg1, freq_reg2;
    reg [31:0] phase_acc;
    reg [31:0] phase_inc;
    reg [63:0] phase_calc;
    reg [7:0] amplitude;
    
    localparam [63:0] PHASE_MULT = 64'd18446744073709551616;
    
    always @(posedge clk) begin
        if (reset) begin
            freq_reg1 <= 32'd0;
            freq_reg2 <= 32'd0;
            phase_acc <= 32'd0;
            phase_inc <= 32'd0;
            wav_out <= 8'h80;
            phase_calc <= 64'd0;
            amplitude <= 8'h80;
        end else begin
            freq_reg1 <= freq;
            freq_reg2 <= freq_reg1;
            
            phase_calc <= freq_reg2 * (PHASE_MULT / 100_000_000);
            phase_inc <= phase_calc[63:32];
            phase_acc <= phase_acc + phase_inc;
            
            // Generate triangle wave
            amplitude <= phase_acc[31] ? ~phase_acc[30:23] : phase_acc[30:23];
            wav_out <= amplitude;
        end
    end
endmodule