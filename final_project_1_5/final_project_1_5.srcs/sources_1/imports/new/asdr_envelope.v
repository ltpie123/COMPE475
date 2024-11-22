`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 11/21/2024
// Design Name: ADSR Envelope Generator
// Module Name: adsr_envelope
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    ADSR (Attack, Decay, Sustain, Release) envelope generator for polyphonic
//    synthesizer. Supports multiple voices with independent envelope tracking.
//
//    The module processes each voice independently, applying ADSR envelope
//    modulation to the input waveforms. Time parameters are specified in
//    milliseconds for intuitive control.
//
// Parameters:
//    NUM_VOICES: Number of simultaneous voices to process (default: 8)
//
// Inputs:
//    - clk: System clock (100MHz)
//    - reset: Active high reset
//    - voice_trigger: Trigger signals for each voice
//    - voice_active: Active status for each voice
//    - attack_time: Attack phase duration (0-65535ms)
//    - decay_time: Decay phase duration (0-65535ms)
//    - sustain_level: Sustain amplitude level (0-255)
//    - release_time: Release phase duration (0-65535ms)
//    - voice_in: Array of input waveforms for each voice
//
// Outputs:
//    - voice_out: Array of envelope-modulated waveforms
//
// Dependencies: None
//
// Notes:
//    - Uses fixed-point math for envelope calculations
//    - Linear envelope curves for each phase
//    - Processes all voices in parallel
//    - Automatically handles voice triggering and release
//
// Revision History:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module adsr_envelope #(
    parameter NUM_VOICES = 8
)(
    input wire clk,                     // System clock (100MHz)
    input wire reset,                   // Active high reset

    // Voice control inputs
    input wire [NUM_VOICES-1:0] voice_trigger,    // Voice start triggers
    input wire [NUM_VOICES-1:0] voice_active,     // Voice active flags

    // ADSR parameters (in milliseconds, converted to clock cycles)
    input wire [15:0] attack_time,     // 0-65535ms
    input wire [15:0] decay_time,      // 0-65535ms
    input wire [7:0] sustain_level,    // 0-255 (8-bit resolution)
    input wire [15:0] release_time,    // 0-65535ms

    // Per-voice audio inputs/outputs
    input wire [7:0] voice_in [0:NUM_VOICES-1],    // Input waveforms
    output reg [7:0] voice_out [0:NUM_VOICES-1]    // Envelope-modulated outputs
);

    // State definitions
    localparam IDLE = 3'd0;
    localparam ATTACK = 3'd1;
    localparam DECAY = 3'd2;
    localparam SUSTAIN = 3'd3;
    localparam RELEASE = 3'd4;

    // Per-voice state tracking
    reg [2:0] voice_state [0:NUM_VOICES-1];
    reg [31:0] voice_counter [0:NUM_VOICES-1];
    reg [7:0] voice_envelope [0:NUM_VOICES-1];

    // Clock cycles per millisecond (for 100MHz clock)
    localparam CYCLES_PER_MS = 100_000;

    // Calculate time values in clock cycles
    wire [31:0] attack_cycles = attack_time * CYCLES_PER_MS;
    wire [31:0] decay_cycles = decay_time * CYCLES_PER_MS;
    wire [31:0] release_cycles = release_time * CYCLES_PER_MS;

    // Calculate rates (in amplitude units per cycle)
    wire [31:0] attack_rate = (attack_cycles > 0) ? (32'd255 * CYCLES_PER_MS) / attack_cycles : 32'd255;
    wire [31:0] decay_rate = (decay_cycles > 0) ? ((255 - sustain_level) * CYCLES_PER_MS) / decay_cycles : 32'd255;
    wire [31:0] release_rate = (release_cycles > 0) ? (sustain_level * CYCLES_PER_MS) / release_cycles : 32'd255;

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                voice_state[i] <= IDLE;
                voice_counter[i] <= 0;
                voice_envelope[i] <= 8'd0;
                voice_out[i] <= 8'd0;
            end
        end else begin
            // Process each voice
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                // Check for new note trigger
                if (voice_trigger[i]) begin
                    voice_state[i] <= ATTACK;
                    voice_counter[i] <= 0;
                end

                // State machine for each voice
                case (voice_state[i])
                    IDLE: begin
                        voice_envelope[i] <= 8'd0;
                    end

                    ATTACK: begin
                        if (!voice_active[i]) begin
                            voice_state[i] <= RELEASE;
                            voice_counter[i] <= 0;
                        end else if (voice_envelope[i] >= 8'd255) begin
                            voice_state[i] <= DECAY;
                            voice_counter[i] <= 0;
                            voice_envelope[i] <= 8'd255;
                        end else begin
                            voice_envelope[i] <= voice_envelope[i] + (attack_rate / CYCLES_PER_MS);
                        end
                    end

                    DECAY: begin
                        if (!voice_active[i]) begin
                            voice_state[i] <= RELEASE;
                            voice_counter[i] <= 0;
                        end else if (voice_envelope[i] <= sustain_level) begin
                            voice_state[i] <= SUSTAIN;
                            voice_envelope[i] <= sustain_level;
                        end else begin
                            voice_envelope[i] <= voice_envelope[i] - (decay_rate / CYCLES_PER_MS);
                        end
                    end

                    SUSTAIN: begin
                        if (!voice_active[i]) begin
                            voice_state[i] <= RELEASE;
                            voice_counter[i] <= 0;
                        end
                        voice_envelope[i] <= sustain_level;
                    end

                    RELEASE: begin
                        if (voice_trigger[i]) begin
                            voice_state[i] <= ATTACK;
                            voice_counter[i] <= 0;
                        end else if (voice_envelope[i] <= 8'd0) begin
                            voice_state[i] <= IDLE;
                            voice_envelope[i] <= 8'd0;
                        end else begin
                            voice_envelope[i] <= voice_envelope[i] - (release_rate / CYCLES_PER_MS);
                        end
                    end
                endcase

                // Apply envelope to voice waveform
                voice_out[i] <= (voice_in[i] * voice_envelope[i]) >> 8;
            end
        end
    end

endmodule
