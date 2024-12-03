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


module tri_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] phase_accumulator;
    reg [31:0] phase_increment;
    reg direction;
    reg [7:0] amplitude;

    // Calculate phase increment
    wire [63:0] phase_inc_calc;
    assign phase_inc_calc = ((freq * 64'h100000000) / 100_000_000);

    always @(posedge clk) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            direction <= 0;
            amplitude <= 0;
            wav_out <= 0;
        end else begin
            // Update phase increment (registered to prevent glitches)
            phase_increment <= phase_inc_calc[31:0];

            // Update phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;

            // Generate triangle wave
            if (phase_accumulator[31]) begin
                // Falling edge of triangle
                amplitude <= ~phase_accumulator[30:23];
            end else begin
                // Rising edge of triangle
                amplitude <= phase_accumulator[30:23];
            end

            wav_out <= amplitude;
        end
    end

endmodule
