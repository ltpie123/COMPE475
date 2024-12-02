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
    output reg [7:0] wav_out
);
    // Wave generator outputs
    wire [7:0] sqr_wav_out;
    wire [7:0] sin_wav_out;
    wire [7:0] saw_wav_out;
    wire [7:0] tri_wav_out;

    // Simple wave generators for testing
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

    // Super simple output selection - no intermediate registers
    always @* begin
        if (reset)
            wav_out = 8'h80;
        else if (!voice_active)
            wav_out = 8'h80;
        else case (wav_sel)
            2'b00: wav_out = saw_wav_out;
            2'b01: wav_out = sqr_wav_out;
            2'b10: wav_out = tri_wav_out;
            2'b11: wav_out = sin_wav_out;
            default: wav_out = saw_wav_out;
        endcase
    end

endmodule