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
    output reg [7:0] wav_out
    );

    // Create intermediate signals for each wave generator's output
    wire [7:0] sqr_wav_out;
    wire [7:0] sin_wav_out;
    wire [7:0] saw_wav_out;
    wire [7:0] tri_wav_out;

    // Instantiate the wave generators, connecting their outputs to the intermediate signals
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

    // Use a clocked always block to select the output wave
    always @(posedge clk) begin
        case (wav_sel)
            2'b00: wav_out <= sqr_wav_out;  // Square wave
            2'b01: wav_out <= sin_wav_out;  // Sine wave
            2'b10: wav_out <= saw_wav_out;  // Sawtooth wave
            2'b11: wav_out <= tri_wav_out;  // Triangle wave
            default: wav_out <= 8'b0;       // Default to zero if selection is invalid
        endcase
    end
endmodule
