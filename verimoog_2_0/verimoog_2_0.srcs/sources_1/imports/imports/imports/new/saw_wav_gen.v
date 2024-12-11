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

module saw_wav_gen(
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    // Pipeline registers
    reg [31:0] freq_reg1, freq_reg2;
    reg [31:0] phase_acc;
    reg [31:0] phase_inc;

    // Intermediate calculation registers - expanded precision
    reg [63:0] phase_calc;  // Full 64-bit precision for calculations
    
    // Constants for phase increment calculation
    localparam [63:0] PHASE_MULT = 64'd18446744073709551615;  // 2^64 / 100_000_000
    
    // First stage - register input frequency
    always @(posedge clk) begin
        if (reset) begin
            freq_reg1 <= 32'd0;
            freq_reg2 <= 32'd0;
            phase_acc <= 32'd0;
            phase_inc <= 32'd0;
            wav_out <= 8'h80;
            phase_calc <= 64'd0;
        end else begin
            freq_reg1 <= freq;
            freq_reg2 <= freq_reg1;
            
            // Calculate phase increment with full precision
            phase_calc <= freq_reg2 * (PHASE_MULT / 100_000_000);
            phase_inc <= phase_calc[63:32];  // Take upper 32 bits
            
            // Accumulate phase
            phase_acc <= phase_acc + phase_inc;
            
            // Generate output
            wav_out <= phase_acc[31:24];
        end
    end

endmodule
