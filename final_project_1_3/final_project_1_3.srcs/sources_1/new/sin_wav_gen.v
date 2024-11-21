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

    reg [31:0] phase_accumulator;     // Phase accumulator
    reg [31:0] phase_increment;       // Phase increment per clock cycle
    parameter integer TABLE_SIZE = 256; // Size of the sine lookup table
    reg [7:0] sine_table [0:TABLE_SIZE-1]; // Sine lookup table

    integer i;

    // Initialize sine wave lookup table
    initial begin
        for (i = 0; i < TABLE_SIZE; i = i + 1) begin
            sine_table[i] = $signed($rtoi($sin(2 * 3.14159 * i / TABLE_SIZE) * 127 + 128));
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            wav_out <= 8'h7f; // Middle value of the sine wave (0.5)
        end else begin
            // Calculate the phase increment based on the frequency
            // phase_increment = (freq * TABLE_SIZE) / Sample_Rate
            // Assuming Sample_Rate is set to 1 MHz (1,000,000 Hz)
            phase_increment <= (freq * TABLE_SIZE) / 1000000; // Ensure this calculation is correct

            // Update the phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;

            // Wrap around the phase accumulator to fit within the table size
            // Use modulo operation correctly
            if (phase_accumulator >= TABLE_SIZE) begin
                phase_accumulator = phase_accumulator % TABLE_SIZE;
            end

            // Output the current sine value
            wav_out <= sine_table[phase_accumulator];

            // Debugging output
            $display("Time: %0t | Freq: %d | Phase Increment: %d | Phase Accumulator: %d | wav_out: %h",
                      $time, freq, phase_increment, phase_accumulator, wav_out);
        end
    end

endmodule
