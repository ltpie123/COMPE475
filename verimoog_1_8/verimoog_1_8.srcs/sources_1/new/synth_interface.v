`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 12:27:33 AM
// Design Name: 
// Module Name: synth_interface
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

module synth_interface(
    input wire clk,
    input wire reset,
    // CPU interface
    input wire [7:0] port_addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire write_e,
    input wire read_e,
    
    // Synthesizer interface
    output reg [1:0] wav_sel,
    output reg [2:0] attack_time,
    output reg [2:0] decay_time,
    output reg [3:0] sustain_level,
    output reg [2:0] release_time
);

    // Register updates on CPU writes
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wav_sel <= 2'b00;
            attack_time <= 3'b000;
            decay_time <= 3'b000;
            sustain_level <= 4'b0000;
            release_time <= 3'b000;
        end
        else if (write_e) begin
            case (port_addr)
                8'h00: wav_sel <= data_in[1:0];
                8'h01: attack_time <= data_in[2:0];
                8'h02: decay_time <= data_in[2:0];
                8'h03: sustain_level <= data_in[3:0];
                8'h04: release_time <= data_in[2:0];
            endcase
        end
    end

    // Handle CPU reads
    always @(*) begin
        if (read_e) begin
            case (port_addr)
                8'h00: data_out = {6'b0, wav_sel};
                8'h01: data_out = {5'b0, attack_time};
                8'h02: data_out = {5'b0, decay_time};
                8'h03: data_out = {4'b0, sustain_level};
                8'h04: data_out = {5'b0, release_time};
                default: data_out = 8'h00;
            endcase
        end
        else
            data_out = 8'h00;
    end

endmodule