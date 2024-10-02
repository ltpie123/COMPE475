`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 12:45:31 PM
// Design Name: 
// Module Name: uart_tx
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

module uart_tx(
    input wire clk,                                  // 100MHz clock from Basys 3
    input wire reset,
    input wire [7:0] data,                           // 8-bit data to be transmitted
    input wire send,                                 // Signal to trigger the transmission
    output reg tx,                                   // Serial data output (UART transmit)
    output reg busy_tx,                              // Transmission busy indicator
    output reg [2:0] current_state
);
    // FSM state declarations
    localparam IDLE  = 3'b000,
               START = 3'b001,
               DATA  = 3'b010,
               STOP  = 3'b011,
               DONE  = 3'b100;

    reg [2:0] next_state;

    parameter BAUD_DIVIDER = 10416;                  // Baud rate divider (for 9600 bps at 100 MHz clock)    // Clock generator instance

    wire clk_gen;                                    // Wire to hold the generated clock
    clk_gen my_clk_gen (
        .clk_in(clk),                                // Input clock (100MHz)
        .reset(reset),                               // Reset signal
        .clk_out(clk_gen)                           // Generated clock output
    );

    // FSM State Transitions
    always @(posedge clk_gen or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;                   // Reset to IDLE state
            tx <= 1;                                 // Idle state for UART (tx high)
            busy_tx <= 0;
        end else begin
            current_state <= next_state;             // Transition to the next state
        end
    end
    
    // FSM Next State Logic and Outputs
    always @(*) begin
        // Default assignments
        next_state = current_state;
        busy_tx = 1; // Assume busy in all states except IDLE
        case (current_state)
            IDLE: begin
                busy_tx = 0;                         // Not busy in IDLE state
                tx = 1;                              // Line is idle (high)
                if (send) begin
                    next_state = START;              // If send signal is high, start transmission
                end
            end
            START: begin
            end
            DATA: begin
            end
            STOP: begin
            end
        endcase
    end
    
    // Sequential block to update counter and bit_index
    always @(posedge clk_gen or posedge reset) begin
        if (reset) begin
        end else begin
            if (current_state == START || current_state == DATA || current_state == STOP) begin
                    if (current_state == DATA) begin
                        end
                    end
                end
            end
        end
    end
endmodule
