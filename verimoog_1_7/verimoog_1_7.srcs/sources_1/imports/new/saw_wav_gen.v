`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/26/2024
// Design Name:
// Module Name: saw_wav_gen
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
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
