`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 01:56:45 PM
// Design Name: 
// Module Name: uart_tx_tb
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

module uart_tx_tb;
    reg clk;
    reg data_en;
    reg [7:0] data;
    wire tx;
    wire fsm_clk;
    wire baud_clk_wire;

    wire [7:0] lastname [0:6];
    assign lastname[0] = "C";
    assign lastname[1] = "h";
    assign lastname[2] = "o";
    assign lastname[3] = "k";
    assign lastname[4] = "e";
    assign lastname[5] = "i";
    assign lastname[6] = "r";

    reg [6:0] index = 0;
    
    // Remove the local state variable and instead use the state output from the uart_tx module
    wire [1:0] state;  // Declare a wire to hold FSM state from the uart_tx module
    
    baud_gen baud_gen00 (
        .clk(clk),
        .baud_clk(baud_clk_wire)
    );
    
    uart_tx uart_tx00 (
        .baud_clk(baud_clk_wire),
        .data_en(data_en),
        .data_in(data),
        .tx(tx),
        .fsm_clk(fsm_clk),
        .fsm_state(state)  // Connect the FSM state output
    );                              
    
    always #10 clk = ~clk;
    
    initial begin
        clk <= 0;
        data_en <= 0;
        @(posedge baud_clk_wire);
        @(posedge baud_clk_wire);
        data_en <= 1;
    end
    
    always @(posedge fsm_clk) begin
        if (index == 6) begin
            data_en <= 0;
        end else begin
            index <= index + 1;
        end
    end

    always @(*) begin
        data <= lastname[index];
    end
    
    // Display statements to output the FSM state and tx output
    always @(posedge fsm_clk) begin
        $display("Time: %t, FSM State: %b, TX: %b", $time, state, tx);
    end

endmodule