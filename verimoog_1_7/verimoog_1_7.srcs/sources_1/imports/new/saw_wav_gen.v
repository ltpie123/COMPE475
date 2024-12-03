`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: 
//
// Create Date: 09/26/2024
// Design Name: Sawtooth Wave Generator
// Module Name: saw_wav_gen
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Phase accumulator-based sawtooth wave generator with configurable frequency.
//    Produces an 8-bit output with linear ramp from 0 to 255.
//
// Key Features:
//    - Variable frequency generation (0-20kHz range)
//    - 8-bit amplitude resolution
//    - Phase-accurate synthesis
//    - Glitch-free frequency changes
//
// Signal Information:
//    Inputs:
//        clk       - 100MHz system clock
//        reset     - Active high reset
//        freq      - 32-bit frequency control word (Hz)
//    Outputs:
//        wav_out   - 8-bit sawtooth wave output
//
// Timing:
//    - Output updates every clock cycle
//    - Phase accumulator overflow determines frequency
//    - 32-bit phase resolution for fine frequency control
//
// Implementation Notes:
//    - Uses fixed-point arithmetic for phase calculation
//    - Direct phase accumulator to output mapping
//    - Phase increment calculation: (freq * 2^32) / clock_freq
//
// Performance:
//    - Frequency Resolution: 0.023 Hz at 100MHz clock
//    - Maximum Frequency: Limited by Nyquist (50MHz)
//    - Actual Usable Range: 0-20kHz for audio
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Consider adding frequency limit checking
//    - Could implement anti-aliasing filtering
//////////////////////////////////////////////////////////////////////////////////

module saw_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] phase_accumulator;
    reg [31:0] phase_increment;

    // Calculate phase increment using 64-bit arithmetic
    wire [63:0] phase_inc_calc;
    assign phase_inc_calc = ((freq * 64'h100000000) / 100_000_000);

    always @(posedge clk) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            wav_out <= 0;
        end else begin
            // Update phase increment (registered to prevent glitches)
            phase_increment <= phase_inc_calc[31:0];

            // Update phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;

            // Use upper 8 bits of phase accumulator for output
            wav_out <= phase_accumulator[31:24];
        end
    end

endmodule
