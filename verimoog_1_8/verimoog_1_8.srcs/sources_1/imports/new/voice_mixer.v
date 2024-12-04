`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/27/2024
// Design Name: Voice Mixer
// Module Name: voice_mixer
// Project Name: Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Mixes multiple 8-bit voice inputs into a single output.
//    Includes scaling to prevent overflow.
//
//////////////////////////////////////////////////////////////////////////////////

module voice_mixer #(
    parameter NUM_VOICES = 8
)(
    input wire clk,
    input wire reset,
    input wire [(NUM_VOICES*8)-1:0] voice_in,   // Packed array format
    input wire [NUM_VOICES-1:0] voice_active,
    output reg [7:0] mix_out
);

    // Calculate sum with extra bits to prevent overflow
    reg [10:0] sum;  // 3 extra bits for up to 8 voices
    reg [7:0] current_voice;  // Temporary register for extracting voice data
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 0;
            mix_out <= 8'h80;  // Center value
        end
        else begin
            // Sum active voices
            sum <= 0;
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                if (voice_active[i]) begin
                    current_voice = voice_in[i*8 +: 8];  // Extract current voice data
                    sum <= sum + current_voice;
                end
            end

            // Scale output based on number of active voices
            case (voice_active)
                0: mix_out <= 8'h80;
                1: mix_out <= sum[7:0];
                2: mix_out <= {1'b0, sum[8:2]};
                3,4: mix_out <= {2'b0, sum[9:3]};
                default: mix_out <= {3'b0, sum[10:4]};
            endcase
        end
    end

endmodule