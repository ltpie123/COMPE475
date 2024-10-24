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

    reg [31:0] phase;
    reg direction;  // 0 = rising, 1 = falling
    
    always @(posedge clk) begin
        if (reset) begin
            phase <= 0;
            wav_out <= 0;
            direction <= 0;  // Start by rising
        end else begin
            phase <= phase + freq;
            wav_out <= {~phase[31], phase[30:7]};
        end
    end

endmodule
