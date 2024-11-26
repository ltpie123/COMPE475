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
    input wire clk,                     
    input wire reset,                   
    input wire [NUM_VOICES-1:0] voice_trigger,    
    input wire [NUM_VOICES-1:0] voice_active,     
    input wire [15:0] attack_time,     
    input wire [15:0] decay_time,      
    input wire [7:0] sustain_level,    
    input wire [15:0] release_time,    
    input wire [(NUM_VOICES*8)-1:0] voice_in,    
    output reg [(NUM_VOICES*8)-1:0] voice_out    
);

    // State definitions and other parameters remain the same
    localparam IDLE = 3'd0;
    localparam ATTACK = 3'd1;
    localparam DECAY = 3'd2;
    localparam SUSTAIN = 3'd3;
    localparam RELEASE = 3'd4;

    // Per-voice state tracking
    reg [2:0] voice_state [0:NUM_VOICES-1];
    reg [31:0] voice_counter [0:NUM_VOICES-1];
    reg [7:0] voice_envelope [0:NUM_VOICES-1];

    // Clock cycles and rates calculations remain the same
    localparam CYCLES_PER_MS = 100_000;
    wire [31:0] attack_cycles = attack_time * CYCLES_PER_MS;
    wire [31:0] decay_cycles = decay_time * CYCLES_PER_MS;
    wire [31:0] release_cycles = release_time * CYCLES_PER_MS;
    wire [31:0] attack_rate = (attack_cycles > 0) ? (32'd255 * CYCLES_PER_MS) / attack_cycles : 32'd255;
    wire [31:0] decay_rate = (decay_cycles > 0) ? ((255 - sustain_level) * CYCLES_PER_MS) / decay_cycles : 32'd255;
    wire [31:0] release_rate = (release_cycles > 0) ? (sustain_level * CYCLES_PER_MS) / release_cycles : 32'd255;

    // New temporary variables for multiplication
    reg [15:0] mult_result;
    reg [7:0] current_voice_in;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voice_out <= 0;  // Reset entire output
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                voice_state[i] <= IDLE;
                voice_counter[i] <= 0;
                voice_envelope[i] <= 8'd0;
            end
        end else begin
            for (i = 0; i < NUM_VOICES; i = i + 1) begin
                // Check for new note trigger
                if (voice_trigger[i]) begin
                    voice_state[i] <= ATTACK;
                    voice_counter[i] <= 0;
                end

                // State machine remains the same
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

                // Modified envelope application using block assignments
                current_voice_in = voice_in[i*8 +: 8];
                mult_result = current_voice_in * voice_envelope[i];
                voice_out[i*8 +: 8] <= mult_result >> 8;
            end
        end
    end

endmodule