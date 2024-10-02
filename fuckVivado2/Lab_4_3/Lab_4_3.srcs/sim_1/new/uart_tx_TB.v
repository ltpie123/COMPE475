`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 12:45:31 PM
// Design Name: 
// Module Name: uart_tx_TB
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


module uart_tx_TB;

    // Testbench signals
    reg clk;                    // 100 MHz clock
    reg reset;                  // Reset signal
    reg [7:0] data;             // 8-bit data to transmit
    reg send;                   // Signal to initiate transmission
    wire tx;                    // Serial output
    wire busy_tx;               // Transmission busy signal
    wire [2:0] current_state;

    // ASCII codes for "CHOKEIR"
    reg [7:0] last_name_ascii [0:6]; // "CHOKEIR" => 7 letters
    integer i;  // Declare the loop variable outside the loop

    // Instantiate the uart_tx module
    uart_tx uut (
        .clk(clk),
        .reset(reset),
        .data(data),
        .send(send),
        .tx(tx),
        .busy_tx(busy_tx),
        .current_state(current_state)
    );

    // Clock generation (100 MHz clock, 10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        send = 0;
        data = 8'b0;

        // Apply reset
        #20;
        reset = 0;
        #20;

        // Load the ASCII codes for "CHOKEIR"
        last_name_ascii[0] = 8'h43; // 'C'
        last_name_ascii[1] = 8'h48; // 'H'
        last_name_ascii[2] = 8'h4F; // 'O'
        last_name_ascii[3] = 8'h4B; // 'K'
        last_name_ascii[4] = 8'h45; // 'E'
        last_name_ascii[5] = 8'h49; // 'I'
        last_name_ascii[6] = 8'h52; // 'R'

        // Start sending each letter in "CHOKEIR"
        for (i = 0; i < 7; i = i + 1) begin  // `integer i` was declared outside the loop
            wait (!busy_tx);               // Wait until UART is no longer busy
            data = last_name_ascii[i];     // Load new data byte
            send = 1;                      // Assert send signal for one clock cycle
            @(posedge clk);                // Wait for one clock cycle
            send = 0;                      // De-assert send signal

            // Optionally, wait until transmission is done if needed
            // Example: Uncomment the following lines if required
            // @(posedge busy_tx);          // Wait until the transmission starts
            // wait (!busy_tx);             // Wait until the UART finishes transmission
        end

        // Wait for some extra time after the last transmission to allow full output
        #50000;  // Wait 1,000,000 ns (1 ms)
        $stop; // End simulation
    end

endmodule
