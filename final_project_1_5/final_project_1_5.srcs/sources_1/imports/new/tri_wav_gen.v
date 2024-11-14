`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024
// Design Name: 
// Module Name: tri_wav_gen
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


module tri_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);
    reg [31:0] phase_accumulator;
    reg [31:0] phase_increment;
    reg direction;
    reg [7:0] amplitude;
    
    // Calculate phase increment
    wire [63:0] phase_inc_calc;
    assign phase_inc_calc = ((freq * 64'h100000000) / 100_000_000);
    
    always @(posedge clk) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            direction <= 0;
            amplitude <= 0;
            wav_out <= 0;
        end else begin
            // Update phase increment (registered to prevent glitches)
            phase_increment <= phase_inc_calc[31:0];
            
            // Update phase accumulator
            phase_accumulator <= phase_accumulator + phase_increment;
            
            // Generate triangle wave
            if (phase_accumulator[31]) begin
                // Falling edge of triangle
                amplitude <= ~phase_accumulator[30:23];
            end else begin
                // Rising edge of triangle
                amplitude <= phase_accumulator[30:23];
            end
            
            wav_out <= amplitude;
        end
    end

endmodule
