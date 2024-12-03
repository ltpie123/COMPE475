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

reg [31:0] counter;
reg [31:0] max;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            wav_out <= 8'h00;
        end else begin
            if (counter >= max) begin
                counter <= 0;
                wav_out <= ~wav_out;  // Toggle output after max period
            end else begin
                counter <= counter + 1;
            end
        end
    end

// Combinational block to calculate max value
// Improved max calculation
    always @(*) begin
        max = (freq > 0) ? (100_000_000 / (2 * freq)) : 32'd100_000_000;
    end
endmodule

