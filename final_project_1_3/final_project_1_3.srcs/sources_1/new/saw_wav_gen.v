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
    input wire [31:0] freq, // Frequency in Hz
    output reg [7:0] wav_out, // Output waveform
    output reg [31:0] counter_debug, // Debug output for counter
    output reg [31:0] period_debug // Debug output for period
);
    reg [31:0] counter;      // Counter for the sawtooth wave
    reg [31:0] period;       // Number of clock cycles for one full wave
    reg [31:0] last_freq;    // To track the last frequency

    // Frequency period calculation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            period <= 32'd1;  // Default to 1 to avoid division by zero
            last_freq <= 32'd0; // Reset last frequency
            period_debug <= 32'd0; // Reset debug output for period
        end else begin
            // Calculate the period based on the frequency
            if (freq > 0) begin
                period <= 50000000 / freq; // Clock cycles for one period
            end
            period_debug <= period; // Update debug output for period
        end
    end

    // Output and counter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wav_out <= 8'd0;   // Reset output
            counter <= 32'd0;  // Reset counter
            counter_debug <= 32'd0; // Reset debug output for counter
        end else begin
            // Check if frequency has changed
            if (freq != last_freq) begin
                wav_out <= 8'd0; // Reset output if frequency changes
                counter <= 32'd0; // Reset counter
                last_freq <= freq; // Update last frequency
            end else begin
                // Increment the counter
                counter <= counter + 1;
                counter_debug <= counter; // Update debug output for counter

                // Generate sawtooth waveform
                if (counter >= period) begin
                    counter <= 32'd0; // Reset counter
                    // Increment output, ensuring it wraps around at 255
                    if (wav_out < 8'd255) begin
                        wav_out <= wav_out + 1; // Increment output
                    end else begin
                        wav_out <= 8'd0; // Reset output if it reaches max
                    end
                end
            end
        end
    end
endmodule
