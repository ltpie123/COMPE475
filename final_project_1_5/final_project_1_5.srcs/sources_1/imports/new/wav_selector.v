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
    input wire voice_active,     // New signal, but won't connect to wave gens yet
    input wire voice_trigger,    // New signal, but won't connect to wave gens yet
    output reg [7:0] wav_out
);
    // Create intermediate signals for each wave generator's output
    wire [7:0] sqr_wav_out;
    wire [7:0] sin_wav_out;
    wire [7:0] saw_wav_out;
    wire [7:0] tri_wav_out;

    // Registered wave select to prevent glitches
    reg [1:0] wav_sel_reg;

    // Register the wave select input
    always @(posedge clk or posedge reset) begin
        if (reset)
            wav_sel_reg <= 2'b00;
        else
            wav_sel_reg <= wav_sel;
    end

    // Instantiate the wave generators (without enable/trigger for now)
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

    // First stage: Combinational wave selection
    reg [7:0] selected_wave;

    always @(*) begin
        if (!voice_active) begin
            selected_wave = 8'h80;  // Center value when voice not active
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

    // Second stage: Register the output
    always @(posedge clk or posedge reset) begin
        if (reset)
            wav_out <= 8'h80;
        else
            wav_out <= selected_wave;
    end

endmodule