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
    input wire [1:0] wav_sel,
    input wire [31:0] freq,
    output reg [7:0] wav_out
    );
    
    wire sqr_wav, sin_wav, saw_wav, tri_wav;
    
    sqr_wav_gen sqr_wav_gen(.clk(clk), .freq(freq), .wav_out(wav_out));
    sin_wav_gen sin_wav_gen(.clk(clk), .freq(freq), .wav_out(wav_out));
    saw_wav_gen saw_wav_gen(.clk(clk), .freq(freq), .wav_out(wav_out));
    tri_wav_gen tri_wav_gen(.clk(clk), .freq(freq), .wav_out(wav_out));
    
    always @(*) begin
        case (wav_sel)
            2'b00: wav_out = sqr_wav;
            2'b01: wav_out = sin_wav;
            2'b10: wav_out = saw_wav;
            2'b11: wav_out = tri_wav;
            default: wav_out = 0;
        endcase
    end
endmodule
