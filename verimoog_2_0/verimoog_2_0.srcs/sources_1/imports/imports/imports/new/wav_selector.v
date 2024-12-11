`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer:
//
// Create Date: 09/26/2024
// Design Name: Waveform Selector
// Module Name: wav_selector
// Project Name: VeriMoog Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    Multiplexer for selecting between different waveform generators.
//    Supports saw, square, triangle, and sine waveforms.
//
// Key Features:
//    - Four waveform types
//    - Glitch-free switching
//    - Voice activity gating
//    - Default to mid-scale when inactive
//
// Signal Information:
//    Inputs:
//        clk           - 100MHz system clock
//        reset         - Active high reset
//        wav_sel[1:0]  - Waveform selection control
//                        00: Sawtooth
//                        01: Square
//                        10: Triangle
//                        11: Sine
//        freq          - 32-bit frequency word
//        voice_active  - Voice gate control
//    Outputs:
//        wav_out       - Selected 8-bit waveform
//
// Implementation Notes:
//    - Combinatorial output selection
//    - Mid-scale (0x80) output when inactive
//    - Instantiates all waveform generators
//    - No output smoothing on switches
//
// Resource Usage:
//    - Four waveform generator instances
//    - Simple multiplexer logic
//    - Shared frequency input
//
// Dependencies:
//    - saw_wav_gen.v
//    - sqr_wav_gen.v
//    - tri_wav_gen.v
//    - sin_wav_gen.v
//
// Revision History:
// Revision 0.01 - Initial design
// Additional Comments:
//    - Could add crossfading between waveforms
//    - Consider adding waveform mixing capability
//////////////////////////////////////////////////////////////////////////////////

module wav_selector(
    input wire clk,
    input wire reset,
    input wire [1:0] wav_sel,
    input wire [31:0] freq,
    input wire voice_active,     
    output reg [7:0] wav_out
);
    // Pipeline registers for control signals
    reg [1:0] wav_sel_reg1, wav_sel_reg2;
    reg voice_active_reg1, voice_active_reg2;
    reg [31:0] freq_reg1, freq_reg2;

    // Wave generator outputs
    wire [7:0] saw_out;
    wire [7:0] sqr_out;
    wire [7:0] tri_out;
    wire [7:0] sin_out;
    
    // Registered wave outputs
    reg [7:0] saw_reg, sqr_reg, tri_reg, sin_reg;

    // First stage - register control inputs
    always @(posedge clk) begin
        if (reset) begin
            wav_sel_reg1 <= 2'b00;
            wav_sel_reg2 <= 2'b00;
            voice_active_reg1 <= 1'b0;
            voice_active_reg2 <= 1'b0;
            freq_reg1 <= 32'd0;
            freq_reg2 <= 32'd0;
        end else begin
            wav_sel_reg1 <= wav_sel;
            wav_sel_reg2 <= wav_sel_reg1;
            voice_active_reg1 <= voice_active;
            voice_active_reg2 <= voice_active_reg1;
            freq_reg1 <= freq;
            freq_reg2 <= freq_reg1;
        end
    end

    // Instantiate optimized wave generators
    saw_wav_gen saw_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq_reg2),
        .wav_out(saw_out)
    );

    sqr_wav_gen sqr_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq_reg2),
        .wav_out(sqr_out)
    );

    tri_wav_gen tri_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq_reg2),
        .wav_out(tri_out)
    );

    sin_wav_gen sin_inst (
        .clk(clk),
        .reset(reset),
        .freq(freq_reg2),
        .wav_out(sin_out)
    );

    // Second stage - register wave outputs
    always @(posedge clk) begin
        if (reset) begin
            saw_reg <= 8'h80;
            sqr_reg <= 8'h80;
            tri_reg <= 8'h80;
            sin_reg <= 8'h80;
        end else begin
            saw_reg <= saw_out;
            sqr_reg <= sqr_out;
            tri_reg <= tri_out;
            sin_reg <= sin_out;
        end
    end

    // Final stage - waveform selection and output
    always @(posedge clk) begin
        if (reset) begin
            wav_out <= 8'h80;
        end else if (!voice_active_reg2) begin
            wav_out <= 8'h80;
        end else begin
            case (wav_sel_reg2)
                2'b00: wav_out <= saw_reg;
                2'b01: wav_out <= sqr_reg;
                2'b10: wav_out <= tri_reg;
                2'b11: wav_out <= sin_reg;
            endcase
        end
    end

endmodule