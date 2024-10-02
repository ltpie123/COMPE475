`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:05:14 PM
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


module uart_tx (
    input wire clk,               // System clock
    input wire rst_n,             // Active low reset
    input wire [7:0] data_in,     // Data input (8 bits)
    input wire send,              // Signal to start sending data
    output reg tx,                // Transmit output (serial)
    output reg busy               // Indicates if UART is busy transmitting
);
    wire clk_out;
    wire clk_enable;
    wire done;
    wire [2:0] bit_count;
    reg [2:0] bit_limit = 8; // Number of data bits
    
    // Send the last name "Chokeir"
    // ASCII representation for "Chokeir"
    reg [7:0] last_name [0:6]; // Array to hold the characters
    initial begin
        last_name[0] = 8'h43; // 'C'
        last_name[1] = 8'h68; // 'h'
        last_name[2] = 8'h6F; // 'o'
        last_name[3] = 8'h6B; // 'k'
        last_name[4] = 8'h65; // 'e'
        last_name[5] = 8'h69; // 'i'
        last_name[6] = 8'h72; // 'r'
        last_name[7] = 8'h00; // null terminator (optional)
    end
    
    // Instantiate Clock Divider
    clk_divider #(.BAUD_RATE_DIV(16)) clk_div (
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_out),
        .clk_enable(clk_enable)
    );

    // Instantiate Bit Counter
    bit_counter bc (
        .clk(clk_out),
        .rst_n(rst_n),
        .enable(clk_enable),
        .bit_limit(bit_limit),
        .count(bit_count),
        .done(done)
    );

    // Instantiate State Machine
    state_machine sm (
        .clk(clk_out),
        .rst_n(rst_n),
        .start(send),
        .clk_enable(clk_enable),
        .done(done),
        .current_state(),
        .next_state()
    );

    // Control the TX output and busy signal
    always @(posedge clk_out or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1; // Idle state of UART is high
            busy <= 0;
        end else begin
            case (sm.current_state)
                state_machine.IDLE: begin
                    busy <= 0;
                end
                state_machine.START: begin
                    tx <= 0; // Start bit (low)
                    busy <= 1;
                end
                state_machine.DATA: begin
                    tx <= data_in[bit_count]; // Send current data bit
                end
                state_machine.STOP: begin
                    tx <= 1; // Stop bit (high)
                end
                state_machine.CLEANUP: begin
                    // Cleanup logic can go here
                end
                default: begin
                    // Default case
                end
            endcase
        end
    end
endmodule
