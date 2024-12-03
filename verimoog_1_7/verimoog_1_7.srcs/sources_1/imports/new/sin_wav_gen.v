`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/27/2024
// Design Name: Sine Wave Generator
// Module Name: sin_wav_gen
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Look-up table based sine wave generator with phase accumulator.
//    Produces band-limited sine waves with minimal harmonic distortion.
//
// Key Features:
//    - 256-point sine look-up table
//    - Phase-accurate frequency synthesis
//    - 8-bit amplitude resolution
//    - Continuous phase operation
//
// Signal Information:
//    Inputs:
//        clk       - 100MHz system clock
//        reset     - Active high reset
//        freq      - 32-bit frequency control word (Hz)
//    Outputs:
//        wav_out   - 8-bit sine wave output
//
// Implementation Details:
//    - Look-up table initialization uses $sin function
//    - Fixed-point phase accumulation
//    - Table size: 256 entries
//    - Output range: 0 to 255 (centered at 128)
//
// Mathematical Basis:
//    - Phase Increment = (freq * 2^32) / clock_freq
//    - Table Index = phase_accumulator[31:24]
//    - Sine Scaling = sin(2? * index / 256) * 127 + 128
//
// Performance:
//    - THD: < 0.5% (theoretical)
//    - Frequency Resolution: 0.023 Hz
//    - Amplitude Resolution: 8 bits
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could implement linear interpolation
//    - Consider larger table for better resolution
//    - Possible cubic interpolation enhancement
//////////////////////////////////////////////////////////////////////////////////

module sin_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] phase_accumulator;
    reg [31:0] phase_increment;
    parameter integer TABLE_SIZE = 256;
    reg [7:0] sine_table [0:TABLE_SIZE-1];

    // Calculate phase increment based on 100 MHz clock
    // phase_increment = (freq * 2^32) / clock_frequency
    // This gives us proper frequency scaling with 32-bit fixed-point math
    wire [63:0] phase_inc_calc;
    assign phase_inc_calc = ((freq * 64'd4294967296) / 100_000_000);

    // Initialize sine wave lookup table
    integer i;
    initial begin
        for (i = 0; i < TABLE_SIZE; i = i + 1) begin
            // Generate sine values between 0 and 255
            sine_table[i] = $rtoi($sin(2.0 * 3.14159 * i / TABLE_SIZE) * 127.0 + 128.0);
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            wav_out <= 8'h80; // Middle value (128)
        end else begin
            // Update phase increment
            phase_increment <= phase_inc_calc[31:0];

            // Update phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;

            // Use the top 8 bits of the phase accumulator to index into the sine table
            wav_out <= sine_table[phase_accumulator[31:24]];
        end
    end

    // Synthesis translate_off
    // Debug logic to verify frequency
    real current_freq;
    always @(phase_increment) begin
        current_freq = (phase_increment * 100_000_000.0) / 4294967296.0;
        $display("Requested Freq: %0d Hz, Actual Freq: %0f Hz", freq, current_freq);
    end
    // Synthesis translate_on

endmodule
