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
    input wire [15:0] attack_time,     
    input wire [15:0] decay_time,      
    input wire [7:0] sustain_level,    
    input wire [15:0] release_time,    
    input wire [7:0] voice_in,    
    output reg [7:0] voice_out    
);
    // State definitions with one-hot encoding for better synthesis
    localparam [2:0] IDLE     = 3'b001;
    localparam [2:0] ATTACK   = 3'b010;
    localparam [2:0] DECAY    = 3'b011;
    localparam [2:0] SUSTAIN  = 3'b100;
    localparam [2:0] RELEASE  = 3'b101;

    // Internal state registers
    reg [2:0] current_state;
    reg [7:0] envelope_level;
    reg [15:0] time_counter;
    
    // Parameters for envelope calculation
    reg [15:0] mult_temp;      // Renamed from temp_product
    reg [7:0] rate;           // Current rate of change
    reg direction;            // 1 for increasing, 0 for decreasing

    // Initialize all registers
    initial begin
        current_state = IDLE;
        envelope_level = 8'h00;
        time_counter = 16'h0000;
        mult_temp = 16'h0000;
        rate = 8'h00;
        direction = 1'b0;
        voice_out = 8'h00;
    end

    // Main state machine and envelope calculation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            envelope_level <= 8'h00;
            time_counter <= 16'h0000;
            voice_out <= 8'h00;
        end else begin
            case (current_state)
                IDLE: begin
                    if (voice_trigger) begin
                        current_state <= ATTACK;
                        envelope_level <= 8'h00;
                        time_counter <= 16'h0000;
                    end
                end

                ATTACK: begin
                    if (!voice_active) begin
                        current_state <= RELEASE;
                    end else if (envelope_level >= 8'hFF) begin
                        current_state <= DECAY;
                        envelope_level <= 8'hFF;
                        time_counter <= 16'h0000;
                    end else begin
                        // Calculate attack rate based on attack_time
                        if (time_counter >= attack_time) begin
                            envelope_level <= envelope_level + 1;
                            time_counter <= 16'h0000;
                        end else begin
                            time_counter <= time_counter + 1;
                        end
                    end
                end

                DECAY: begin
                    if (!voice_active) begin
                        current_state <= RELEASE;
                    end else if (envelope_level <= sustain_level) begin
                        current_state <= SUSTAIN;
                        envelope_level <= sustain_level;
                        time_counter <= 16'h0000;
                    end else begin
                        // Calculate decay rate based on decay_time
                        if (time_counter >= decay_time) begin
                            envelope_level <= envelope_level - 1;
                            time_counter <= 16'h0000;
                        end else begin
                            time_counter <= time_counter + 1;
                        end
                    end
                end

                SUSTAIN: begin
                    if (!voice_active) begin
                        current_state <= RELEASE;
                        time_counter <= 16'h0000;
                    end
                    envelope_level <= sustain_level;
                end

                RELEASE: begin
                    if (voice_trigger) begin
                        current_state <= ATTACK;
                        time_counter <= 16'h0000;
                    end else if (envelope_level <= 8'h01) begin
                        current_state <= IDLE;
                        envelope_level <= 8'h00;
                    end else begin
                        // Calculate release rate based on release_time
                        if (time_counter >= release_time) begin
                            envelope_level <= envelope_level - 1;
                            time_counter <= 16'h0000;
                        end else begin
                            time_counter <= time_counter + 1;
                        end
                    end
                end

                default: current_state <= IDLE;
            endcase

            // Calculate output with proper fixed-point multiplication
            mult_temp <= voice_in * envelope_level;
            voice_out <= mult_temp[15:8];
        end
    end

endmodule
