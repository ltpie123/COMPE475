`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:16:05 PM
// Design Name: 
// Module Name: tb_uart_tx
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

module tb_uart_tx;

// Parameters
parameter BAUD_RATE = 9600;
parameter BAUD_RATE_DIV = 10417; // Setting for 9600 baud rate
parameter DATA_WIDTH = 8; // 8 bits for each character

// Signals
reg clk;              // Clock signal for clk_gen
reg rst_n;            // Reset signal
reg [DATA_WIDTH-1:0] data_in; // Data input for UART
reg send;             // Signal to send data
wire tx;              // Transmitted data output
wire busy;            // Busy signal from UART
wire clk_out;        // Output clock from clk_gen

// Instantiate the clock generator
clk_gen clk_generator (
    .clk(clk),
    .rst_n(rst_n),
    .clk_out(clk_out)  // Connect the output clock signal
);

// Instantiate the UART transmitter
uart_tx uut (
    .clk(clk_out),  // Use the output clock from clk_gen
    .rst_n(rst_n),
    .data_in(data_in),
    .send(send),
    .tx(tx),
    .busy(busy)
);

// Test procedure
initial begin
    // Initialize signals
    clk = 0;                // Start with clock low
    rst_n = 0;              // Start with reset active
    data_in = 8'h00;        // Initialize data input
    send = 0;               // Initialize send signal

    // Release reset
    #10 rst_n = 1;         // Deactivate reset after 10 time units

    // Wait for clock to stabilize
    #10;

    // Load data to send
    data_in = 8'h43; // 'C'
    send = 1;        // Signal to send data
    #10 send = 0;    // Release send signal after 10 time units

    // Wait for transmission to complete
    while (busy) begin
        #10; // Wait until busy signal is low
    end

    // Continue sending the rest of "Chokeir"
    data_in = 8'h68; // 'h'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    data_in = 8'h6F; // 'o'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    data_in = 8'h6B; // 'k'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    data_in = 8'h65; // 'e'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    data_in = 8'h69; // 'i'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    data_in = 8'h72; // 'r'
    send = 1;
    #10 send = 0;

    while (busy) begin
        #10; 
    end

    // End the simulation
    $finish;
end

// Generate clock signal
always #5 clk = ~clk; // Clock period of 10 time units

endmodule
