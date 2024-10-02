`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 07:26:44 PM
// Design Name: 
// Module Name: synth
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


module synth(
    input wire clk,
    input wire reset,
    input wire [6:0] midi_in,
    input wire [1:0] wav_sel,
    output wire [7:0] wav_out
    );
    
    wire [31:0] freq;
    
    midi_to_freq midi_freq_inst (
        .midi_in(midi_in),
        .freq_out(freq)
    );
    
    wire [7:0] sqr_wav_out, sin_wav_out, saw_wav_out, tri_wav_out;

    //instantiate waveform generators
    sqr_wav_gen sqr_wav_gen_inst(
        .clk(clk),
        .freq(freq),
        .wav_out(sqr_wav_out)
    );
    
    sin_wav_gen sin_wav_gen_inst(
        .clk(clk),
        .freq(freq),
        .wav_out(sin_wav_out)
    );
    
    saw_wav_gen saw_wav_gen_inst(
        .clk(clk),
        .freq(freq),
        .wav_out(saw_wav_out)
    );
    
    tri_wav_gen tri_wav_gen_inst(
        .clk(clk),
        .freq(freq),
        .wav_out(tri_wav_out)
    );
    
    //waveform selection logic
    reg [7:0] wav_out_reg;
    
    always @(*) begin
        case (wav_sel)
            2'b00: wav_out_reg = sqr_wav_out;
            2'b01: wav_out_reg = sin_wav_out;
            2'b10: wav_out_reg = saw_wav_out;
            2'b11: wav_out_reg = tri_wav_out;
            default: wav_out_reg = 8'd0;
        endcase
    end
    
    assign wav_out = wav_out_reg;
    
endmodule