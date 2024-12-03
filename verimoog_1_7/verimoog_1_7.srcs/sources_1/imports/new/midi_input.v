`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Elias Chokeir
//
// Create Date: 09/26/2024 09:15:00 PM
// Design Name: MIDI Input Interface
// Module Name: midi_input
// Project Name: Synthesizer
// Target Devices: Generic FPGA
// Tool Versions:
// Description:
//    MIDI input interface that receives serial MIDI data and decodes MIDI messages.
//    - Implements MIDI protocol with 31250 baud rate
//    - Handles Note On (0x90) and Note Off (0x80) messages
//    - Outputs 7-bit MIDI note number and note on/off status
//    - Compatible with standard MIDI devices through UART interface
//
// Dependencies: None
//
// Inputs:
//    - clk: System clock (assumed 100MHz)
//    - reset: Active high reset
//    - midi_rx: Serial MIDI input signal
//
// Outputs:
//    - midi_note[6:0]: MIDI note number (0-127)
//    - note_on: High when note is active, low when note is off
//    - note_valid: Pulses high for one clock cycle when new note data is valid
//
// Expected MIDI Message Format:
//    Status Byte (1xxx xxxx) - Note On (0x90) or Note Off (0x80)
//    Data Byte 1 (0xxx xxxx) - Note number (0-127)
//    Data Byte 2 (0xxx xxxx) - Velocity (0-127, 0 velocity Note On = Note Off)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//    - Current implementation ignores MIDI velocity data
//    - Only processes channel 1 MIDI messages
//    - Does not handle MIDI Running Status
//
//////////////////////////////////////////////////////////////////////////////////

module midi_input (
    input wire clk,              // System clock
    input wire reset,            // Active high reset
    input wire midi_rx,          // MIDI serial input
    output reg [6:0] midi_note,  // MIDI note number
    output reg note_on,          // Note on/off status
    output reg note_valid        // Valid note received
);

    // MIDI uses 31250 baud rate
    // Calculate the number of system clock cycles per MIDI bit
    // Assuming system clock is 100MHz:
    // 100MHz / 31250 = 3200 cycles per MIDI bit
    parameter CLKS_PER_BIT = 3200;
    parameter CLKS_PER_HALF_BIT = CLKS_PER_BIT/2;

    // MIDI message state machine states
    localparam IDLE = 3'd0;
    localparam START_BIT = 3'd1;
    localparam DATA_BITS = 3'd2;
    localparam STOP_BIT = 3'd3;
    localparam PROCESS_BYTE = 3'd4;

    // MIDI message bytes
    localparam NOTE_ON = 8'h90;
    localparam NOTE_OFF = 8'h80;

    // State variables
    reg [2:0]  state;
    reg [15:0] bit_counter;
    reg [7:0]  rx_data;
    reg [3:0]  bit_index;

    // MIDI message processing
    reg [7:0] status_byte;
    reg [7:0] data_byte1;
    reg [7:0] data_byte2;
    reg [1:0] byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            rx_data <= 0;
            bit_index <= 0;
            byte_count <= 0;
            status_byte <= 0;
            data_byte1 <= 0;
            data_byte2 <= 0;
            midi_note <= 0;
            note_on <= 0;
            note_valid <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    note_valid <= 0;
                    if (!midi_rx) begin  // Start bit detected
                        state <= START_BIT;
                        bit_counter <= 0;
                    end
                end

                START_BIT: begin
                    if (bit_counter == CLKS_PER_BIT - 1) begin
                        state <= DATA_BITS;
                        bit_counter <= 0;
                        bit_index <= 0;
                        rx_data <= 0;
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end

                DATA_BITS: begin
                    if (bit_counter == CLKS_PER_BIT - 1) begin
                        bit_counter <= 0;
                        rx_data[bit_index] <= midi_rx;

                        if (bit_index == 7)
                            state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end

                STOP_BIT: begin
                    if (bit_counter == CLKS_PER_BIT - 1) begin
                        state <= PROCESS_BYTE;
                        bit_counter <= 0;
                    end
                    else
                        bit_counter <= bit_counter + 1;
                end

                PROCESS_BYTE: begin
                    if (rx_data[7] == 1) begin  // Status byte
                        status_byte <= rx_data;
                        byte_count <= 0;
                    end
                    else begin  // Data byte
                        if (byte_count == 0) begin
                            data_byte1 <= rx_data;
                            byte_count <= 1;
                        end
                        else begin
                            data_byte2 <= rx_data;
                            byte_count <= 0;

                            // Process complete MIDI message
                            if (status_byte == NOTE_ON && data_byte2 != 0) begin
                                midi_note <= data_byte1[6:0];
                                note_on <= 1;
                                note_valid <= 1;
                            end
                            else if (status_byte == NOTE_OFF ||
                                   (status_byte == NOTE_ON && data_byte2 == 0)) begin
                                midi_note <= data_byte1[6:0];
                                note_on <= 0;
                                note_valid <= 1;
                            end
                        end
                    end
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule