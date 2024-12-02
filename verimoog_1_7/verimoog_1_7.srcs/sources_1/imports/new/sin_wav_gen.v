`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024 11:46:18 AM
// Design Name:
// Module Name: sin_wav_gen
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   A sine wave generator that produces an 8-bit sine output based on the input frequency.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File created
// Additional Comments:
//
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
