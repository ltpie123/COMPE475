`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024
// Design Name: PWM Audio Output
// Module Name: pwm_audio
// Project Name: Synthesizer
// Target Devices: Basys 3
// Tool Versions:
// Description:
//    Converts 8-bit audio samples to PWM output for audio generation.
//    Uses high frequency PWM to create analog-like output through
//    an RC low-pass filter.
//
// Dependencies: None
//
// Notes:
//    - PWM frequency should be much higher than audio frequency
//    - Recommended external circuit:
//      * Connect PWM output to RC low-pass filter
//      * Recommended values: R = 1kê, C = 10nF
//      * Cutoff frequency = 1/(2ã*RC) ÷ 16kHz
//
//////////////////////////////////////////////////////////////////////////////////

module pwm_audio(
    input wire clk,              // 100MHz clock
    input wire reset,
    input wire [7:0] audio_in,   // 8-bit audio input
    output reg pwm_out          // PWM output
);

    reg [7:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'd0;
            pwm_out <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
            pwm_out <= (audio_in > counter);
        end
    end

endmodule