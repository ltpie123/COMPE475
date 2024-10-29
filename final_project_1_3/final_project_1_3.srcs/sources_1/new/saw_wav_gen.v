`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024
// Design Name: 
// Module Name: saw_wav_gen
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

module saw_wav_gen (
    input wire clk,
    input wire reset,
    input wire [31:0] freq,
    output reg [7:0] wav_out
);

    reg [31:0] counter;  // Counter for generating the sawtooth
    reg [31:0] max_count; // Maximum count value based on frequency

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            wav_out <= 0;
            max_count <= 0;
        end else begin
            // Calculate max_count based on the frequency (assuming clk is 100 MHz)
            if (freq > 0) begin
                max_count <= (100_000_000 / freq) - 1; // Adjust for the clock frequency
            end else begin
                max_count <= 0; // Prevent division by zero if freq is zero
            end

            // Increment the counter
            if (counter < max_count) begin
                counter <= counter + 1;
            end else begin
                counter <= 0; // Reset counter for the next cycle
            end
            
            // Scale counter value to 8 bits for output
            wav_out <= (counter * 255) / max_count; 
        end
    end

endmodule
