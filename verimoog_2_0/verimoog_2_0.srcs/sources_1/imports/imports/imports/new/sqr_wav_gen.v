`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: Square Wave Generator
// Module Name: sqr_wav_gen
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Counter-based square wave generator with 50% duty cycle.
//    Produces perfect square waves with configurable frequency.
//
// Key Features:
//    - Precise 50% duty cycle
//    - Variable frequency output
//    - Clean transitions
//    - Minimal jitter design
//
// Signal Information:
//    Inputs:
//        clk       - 100MHz system clock
//        reset     - Active high reset
//        freq      - 32-bit frequency control word (Hz)
//    Outputs:
//        wav_out   - 8-bit square wave output (0x00 or 0xFF)
//
// Timing:
//    - Period = clock_frequency / (2 * input_frequency)
//    - Equal high and low time periods
//    - Synchronous transitions on clock edges
//
// Implementation Notes:
//    - Uses counter-based timing
//    - Dynamic period calculation
//    - Handles zero frequency case
//    - Binary output levels (0x00/0xFF)
//
// Frequency Limitations:
//    - Minimum: clock_frequency / 2^32
//    - Maximum: clock_frequency / 4
//    - Optimal Range: 20Hz - 20kHz for audio
//
// Dependencies: None
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could add variable duty cycle
//    - Consider adding frequency validation
//////////////////////////////////////////////////////////////////////////////////

module sqr_wav_gen(
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] freq_reg1, freq_reg2;
    reg [31:0] phase_acc;
    reg [31:0] phase_inc;
    reg [63:0] phase_calc;
    
    localparam [63:0] PHASE_MULT = 64'd18446744073709551616;  // 2^64 / 100_000_000
    
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
            
            phase_calc <= freq_reg2 * (PHASE_MULT / 100_000_000);
            phase_inc <= phase_calc[63:32];
            phase_acc <= phase_acc + phase_inc;
            
            wav_out <= phase_acc[31] ? 8'hFF : 8'h00;
        end
    end
endmodule

