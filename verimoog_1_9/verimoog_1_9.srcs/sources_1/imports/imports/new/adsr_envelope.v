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

module adsr_envelope(
    input wire clk,
    input wire reset,
    input wire voice_trigger,
    input wire voice_active,
    input wire [7:0] attack_time,     // Changed from 16-bit
    input wire [7:0] decay_time,      // Changed from 16-bit
    input wire [7:0] sustain_level,   // Already 8-bit
    input wire [7:0] release_time,    // Changed from 16-bit
    input wire [7:0] voice_in,
    output reg [7:0] voice_out
);
    // State definitions
    localparam IDLE = 3'd0;
    localparam ATTACK = 3'd1;
    localparam DECAY = 3'd2;
    localparam SUSTAIN = 3'd3;
    localparam RELEASE = 3'd4;

    // State tracking
    reg [2:0] state;
    reg [7:0] envelope;
    reg [15:0] mult_temp;

    // Simple fixed rates for testing
    parameter ATTACK_STEP = 8'd1;
    parameter DECAY_STEP = 8'd1;
    parameter RELEASE_STEP = 8'd1;

    // Debug output
    initial begin
        state = IDLE;
        envelope = 8'h00;
        voice_out = 8'h00;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            envelope <= 8'h00;
            voice_out <= 8'h00;
        end else begin
            // First update envelope based on state
            case (state)
                IDLE: begin
                    envelope <= 8'h00;
                    if (voice_trigger)
                        state <= ATTACK;
                end

                ATTACK: begin
                    if (!voice_active) begin
                        state <= RELEASE;
                    end else if (envelope >= 8'hFF) begin
                        state <= DECAY;
                        envelope <= 8'hFF;
                    end else begin
                        envelope <= envelope + ATTACK_STEP;
                    end
                end

                DECAY: begin
                    if (!voice_active) begin
                        state <= RELEASE;
                    end else if (envelope <= sustain_level) begin
                        state <= SUSTAIN;
                        envelope <= sustain_level;
                    end else begin
                        envelope <= envelope - DECAY_STEP;
                    end
                end

                SUSTAIN: begin
                    if (!voice_active)
                        state <= RELEASE;
                    envelope <= sustain_level;
                end

                RELEASE: begin
                    if (voice_trigger) begin
                        state <= ATTACK;
                    end else if (envelope <= RELEASE_STEP) begin
                        state <= IDLE;
                        envelope <= 8'h00;
                    end else begin
                        envelope <= envelope - RELEASE_STEP;
                    end
                end

                default: state <= IDLE;
            endcase

            // Then update output
            mult_temp <= voice_in * envelope;
            voice_out <= mult_temp[15:8];
        end
    end

endmodule