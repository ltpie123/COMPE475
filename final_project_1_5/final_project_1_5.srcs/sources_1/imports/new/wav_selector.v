`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/26/2024 08:04:55 PM
// Design Name:
// Module Name: wav_selector
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

module wav_selector(
    input wire clk,
    input wire reset,
    input wire [1:0] wav_sel,
    input wire [31:0] freq,
    input wire voice_active,     
    input wire voice_trigger,    
    // Add ADSR parameters
    input wire [15:0] attack_time,
    input wire [15:0] decay_time,
    input wire [7:0] sustain_level,
    input wire [15:0] release_time,
    output reg [7:0] wav_out
);
    // Your existing signals
    wire [7:0] sqr_wav_out;
    wire [7:0] sin_wav_out;
    wire [7:0] saw_wav_out;
    wire [7:0] tri_wav_out;
    reg [1:0] wav_sel_reg;
    
    // ADSR signals adjusted for single voice
    wire [7:0] voice_out;
    reg [7:0] selected_wave;

    // Keep your existing wave generator instantiations
    sqr_wav_gen sqr_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(sqr_wav_out)
    );

    sin_wav_gen sin_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(sin_wav_out)
    );

    saw_wav_gen saw_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(saw_wav_out)
    );

    tri_wav_gen tri_wav_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq),
        .wav_out(tri_wav_out)
    );

    // Add ADSR envelope generator (configured for single voice)
    adsr_envelope #(
        .NUM_VOICES(1)
    ) adsr_inst (
        .clk(clk),
        .reset(reset),
        .voice_trigger(voice_trigger),      // Single bit
        .voice_active(voice_active),        // Single bit
        .attack_time(attack_time),
        .decay_time(decay_time),
        .sustain_level(sustain_level),
        .release_time(release_time),
        .voice_in(selected_wave),           // Single 8-bit input
        .voice_out(voice_out)              // Single 8-bit output
    );

    // Wave selection logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            wav_sel_reg <= 2'b00;
        else
            wav_sel_reg <= wav_sel;
    end

    // Wave selection mux
    always @(*) begin
        if (!voice_active) begin
            selected_wave = 8'h80;
        end else begin
            case (wav_sel_reg)
                2'b00: selected_wave = saw_wav_out;
                2'b01: selected_wave = sqr_wav_out;
                2'b10: selected_wave = tri_wav_out;
                2'b11: selected_wave = sin_wav_out;
                default: selected_wave = 8'h80;
            endcase
        end
    end

    // Final output stage - use ADSR output directly
    always @(posedge clk or posedge reset) begin
        if (reset)
            wav_out <= 8'h80;
        else
            wav_out <= voice_out;
    end

endmodule